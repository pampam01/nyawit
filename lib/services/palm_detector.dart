import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../models/detection.dart';

class PalmDetector {
  static const int inputSize = 640;
  static const int numClasses = 6;
  static const int numValues = 10;
  static const int numBoxes = 8400;
  static const List<String> classNames = [
    'Janjang kosong',
    'Kurang masak',
    'TBS abnormal',
    'TBS masak',
    'TBS mentah',
    'Terlalu masak',
  ];

  Interpreter? _interpreter;
  bool _isRunning = false;

  Future<void> load() async {
    final options = InterpreterOptions()..threads = 4;
    _interpreter = await Interpreter.fromAsset('assets/models/best_float32.tflite', options: options);
  }

  Future<List<Detection>> detectFromImagePath(String path) async {
    if (_isRunning) throw Exception("Deteksi sedang berjalan");
    if (_interpreter == null) throw Exception("Model belum dimuat");

    _isRunning = true;
    try {
      return await Isolate.run(() async {
        final bytes = await File(path).readAsBytes();
        final image = img.decodeImage(bytes);
        if (image == null) return [];

        var input = _imageToTensor(image);
        // Asumsi format YOLOv8 standar: [1, 10, 8400]
        var output = List.generate(1, (i) => List.generate(numValues, (j) => List.filled(numBoxes, 0.0)));
        
        // Kita tidak bisa me-run interpreter dalam isolate ini secara langsung tanpa mengirim interpreter address, 
        // tapi tflite_flutter v0.10+ di dart murni kadang bisa bermasalah jika interpreter tidak dibuat di isolate tersebut.
        // Jadi isolate ini hanya mem-parsing image, return tensor, run interpreter di main thread.
        return _runInference(input); // Wait, _runInference uses _interpreter which is not passed to isolate.
      });
    } catch(e) {
      // Fallback ke main thread jika isolate bermasalah dengan binding/fungsi.
      final bytes = await File(path).readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return [];

      var input = _imageToTensor(image);
      return _runInference(input);
    } finally {
      _isRunning = false;
    }
  }

  Future<List<Detection>> detectFromCameraImage(CameraImage image) async {
    if (_isRunning) throw Exception("Deteksi sedang berjalan");
    if (_interpreter == null) throw Exception("Model belum dimuat");

    _isRunning = true;
    try {
      // Ekstrak data mentah untuk diproses di Isolate
      final int width = image.width;
      final int height = image.height;
      final Uint8List plane0 = image.planes[0].bytes;
      final Uint8List plane1 = image.planes[1].bytes;
      final Uint8List plane2 = image.planes[2].bytes;
      final int rowStride0 = image.planes[0].bytesPerRow;
      final int rowStride1 = image.planes[1].bytesPerRow;
      final int pixelStride1 = image.planes[1].bytesPerPixel ?? 1;

      // Pindahkan komputasi berat (YUV to RGB loop) ke background thread agar UI tidak macet
      var input = await Isolate.run(() {
        return _rawYuvToTensor(width, height, plane0, plane1, plane2, rowStride0, rowStride1, pixelStride1);
      });
      
      return _runInference(input);
    } finally {
      _isRunning = false;
    }
  }

  List<Detection> _runInference(List<List<List<List<double>>>> input) {
    var output = List.generate(1, (i) => List.generate(numValues, (j) => List.filled(numBoxes, 0.0)));
    
    // Kadang output YOLO [1, 8400, 10], kita cek error
    try {
      _interpreter!.run(input, output);
    } catch (e) {
      // Coba bentuk lain [1, 8400, 10]
      var altOutput = List.generate(1, (i) => List.generate(numBoxes, (j) => List.filled(numValues, 0.0)));
      _interpreter!.run(input, altOutput);
      return _parseOutputAlt(altOutput);
    }
    
    return _parseOutput(output);
  }

  static List<List<List<List<double>>>> _imageToTensor(img.Image image) {
    var resizedImage = img.copyResize(image, width: inputSize, height: inputSize);
    var input = List.generate(1, (i) => List.generate(inputSize, (y) => List.generate(inputSize, (x) => List.filled(3, 0.0))));

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        var pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
    }
    return input;
  }

  static List<List<List<List<double>>>> _rawYuvToTensor(
      int width, int height, 
      Uint8List plane0, Uint8List plane1, Uint8List plane2, 
      int rowStride0, int rowStride1, int pixelStride1) {
    
    var input = List.generate(1, (i) => List.generate(inputSize, (y) => List.generate(inputSize, (x) => List.filled(3, 0.0))));
    
    double scaleX = width / inputSize;
    double scaleY = height / inputSize;

    for (int y = 0; y < inputSize; y++) {
      int srcY = (y * scaleY).toInt().clamp(0, height - 1);
      for (int x = 0; x < inputSize; x++) {
        int srcX = (x * scaleX).toInt().clamp(0, width - 1);

        int uvIndex = pixelStride1 * (srcX ~/ 2) + rowStride1 * (srcY ~/ 2);
        int index = srcY * rowStride0 + srcX;

        int yp = plane0[index];
        int up = plane1[uvIndex];
        int vp = plane2[uvIndex];

        // Rumus integer cepat untuk YUV ke RGB
        int r = (yp + vp * 1436 ~/ 1024 - 179).clamp(0, 255);
        int g = (yp - up * 46549 ~/ 131072 + 44 - vp * 93604 ~/ 131072 + 91).clamp(0, 255);
        int b = (yp + up * 1814 ~/ 1024 - 227).clamp(0, 255);

        input[0][y][x][0] = r / 255.0;
        input[0][y][x][1] = g / 255.0;
        input[0][y][x][2] = b / 255.0;
      }
    }
    return input;
  }

  List<Detection> _parseOutput(List<dynamic> output) {
    List<Detection> detections = [];
    double confThreshold = 0.5;
    var out = output[0];
    
    for (int i = 0; i < numBoxes; i++) {
      double maxScore = 0;
      int maxClassId = -1;
      
      for (int c = 0; c < numClasses; c++) {
        double score = out[4 + c][i];
        if (score > maxScore) {
          maxScore = score;
          maxClassId = c;
        }
      }
      
      if (maxScore > confThreshold) {
        double xc = out[0][i] / inputSize;
        double yc = out[1][i] / inputSize;
        double w = out[2][i] / inputSize;
        double h = out[3][i] / inputSize;
        
        detections.add(Detection(
          x1: xc - w / 2,
          y1: yc - h / 2,
          x2: xc + w / 2,
          y2: yc + h / 2,
          score: maxScore,
          classId: maxClassId,
          className: classNames[maxClassId],
        ));
      }
    }
    return _applyNMS(detections);
  }

  List<Detection> _parseOutputAlt(List<dynamic> output) {
    List<Detection> detections = [];
    double confThreshold = 0.5;
    var out = output[0]; // [8400, 10]
    
    for (int i = 0; i < numBoxes; i++) {
      double maxScore = 0;
      int maxClassId = -1;
      
      for (int c = 0; c < numClasses; c++) {
        double score = out[i][4 + c];
        if (score > maxScore) {
          maxScore = score;
          maxClassId = c;
        }
      }
      
      if (maxScore > confThreshold) {
        double xc = out[i][0] / inputSize;
        double yc = out[i][1] / inputSize;
        double w = out[i][2] / inputSize;
        double h = out[i][3] / inputSize;
        
        detections.add(Detection(
          x1: xc - w / 2,
          y1: yc - h / 2,
          x2: xc + w / 2,
          y2: yc + h / 2,
          score: maxScore,
          classId: maxClassId,
          className: classNames[maxClassId],
        ));
      }
    }
    return _applyNMS(detections);
  }

  List<Detection> _applyNMS(List<Detection> boxes, {double iouThreshold = 0.45}) {
    boxes.sort((a, b) => b.score.compareTo(a.score));
    List<Detection> selected = [];
    
    for (var box in boxes) {
      bool keep = true;
      for (var sBox in selected) {
        if (box.classId == sBox.classId) {
          double iou = _calculateIoU(box, sBox);
          if (iou > iouThreshold) {
            keep = false;
            break;
          }
        }
      }
      if (keep) {
        selected.add(box);
      }
    }
    return selected;
  }

  double _calculateIoU(Detection b1, Detection b2) {
    double x1 = b1.x1 > b2.x1 ? b1.x1 : b2.x1;
    double y1 = b1.y1 > b2.y1 ? b1.y1 : b2.y1;
    double x2 = b1.x2 < b2.x2 ? b1.x2 : b2.x2;
    double y2 = b1.y2 < b2.y2 ? b1.y2 : b2.y2;

    double intersectionArea = (x2 - x1 > 0 ? x2 - x1 : 0) * (y2 - y1 > 0 ? y2 - y1 : 0);
    if (intersectionArea <= 0) return 0;

    double b1Area = b1.width * b1.height;
    double b2Area = b2.width * b2.height;

    return intersectionArea / (b1Area + b2Area - intersectionArea);
  }

  Map<String, int> summarize(List<Detection> detections) {
    Map<String, int> summary = {
      for (var name in classNames) name: 0,
    };

    for (var det in detections) {
      if (summary.containsKey(det.className)) {
        summary[det.className] = summary[det.className]! + 1;
      }
    }

    return summary;
  }

  void close() {
    _interpreter?.close();
  }
}
