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

  bool _isRunning = false;

  Future<void> load() async {
    // Inisialisasi TFLite model di sini
  }

  Future<List<Detection>> detectFromImagePath(String path) async {
    if (_isRunning) {
      throw Exception("Deteksi sedang berjalan");
    }

    _isRunning = true;
    
    try {
      // Implementasi TFLite untuk gambar di sini
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    } finally {
      _isRunning = false;
    }
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
    // Dispose TFLite interpreter
  }
}
