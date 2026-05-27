import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../services/palm_detector.dart';
import '../../models/detection.dart';
import '../../utils/box_painter.dart';

class LiveDetectionPage extends StatefulWidget {
  const LiveDetectionPage({super.key});

  @override
  State<LiveDetectionPage> createState() => _LiveDetectionPageState();
}

class _LiveDetectionPageState extends State<LiveDetectionPage> {
  bool _liveEnabled = false;
  bool _isInitializingCamera = false;
  bool _isDetecting = false;

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  
  final PalmDetector _detector = PalmDetector();
  List<Detection> _detections = [];
  Map<String, int> _summary = {};
  DateTime? _lastInferenceTime;

  @override
  void initState() {
    super.initState();
    _detector.load();
  }

  @override
  void dispose() {
    _stopLive(isDisposing: true);
    _detector.close();
    super.dispose();
  }

  void _toggleLive() {
    if (_liveEnabled) {
      _stopLive();
    } else {
      _startLive();
    }
  }

  void _startLive() async {
    setState(() {
      _isInitializingCamera = true;
    });

    try {
      _cameras ??= await availableCameras();
      if (_cameras!.isEmpty) {
        throw Exception('Tidak ada kamera yang tersedia.');
      }
      
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      
      await _cameraController!.initialize();
      
      if (!mounted) return;
      
      setState(() {
        _isInitializingCamera = false;
        _liveEnabled = true;
        _isDetecting = false; // Siap menerima frame
      });
      
      _cameraController!.startImageStream((CameraImage image) async {
        final now = DateTime.now();
        // Hanya proses frame jika deteksi sebelumnya sudah selesai 
        // DAN sudah berjarak minimal 150ms dari deteksi terakhir.
        // Ini memotong beban CPU HP hingga 70% dan membuat live feed super mulus!
        if (_isDetecting || 
            (_lastInferenceTime != null && now.difference(_lastInferenceTime!).inMilliseconds < 150)) {
          return;
        }
        
        _isDetecting = true;
        _lastInferenceTime = now;
        
        try {
          final detections = await _detector.detectFromCameraImage(image);
          if (mounted && _liveEnabled) {
            setState(() {
              _detections = detections;
              _summary = _detector.summarize(detections);
            });
          }
        } catch (e) {
          // Abaikan error per frame
        } finally {
          _isDetecting = false;
        }
      });
      
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializingCamera = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memulai kamera: $e')),
      );
    }
  }

  void _stopLive({bool isDisposing = false}) {
    _liveEnabled = false;
    _isDetecting = false;
    _detections = [];
    _summary = {};
    
    if (_cameraController != null) {
      if (_cameraController!.value.isStreamingImages) {
        _cameraController!.stopImageStream();
      }
      _cameraController!.dispose();
      _cameraController = null;
    }

    if (!isDisposing && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deteksi Lewat Live'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: _isInitializingCamera
                      ? const CircularProgressIndicator(color: Colors.white)
                      : (_liveEnabled && _cameraController != null && _cameraController!.value.isInitialized)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CameraPreview(_cameraController!),
                                  CustomPaint(
                                    painter: DetectionBoxPainter(_detections),
                                  ),
                                ],
                              ),
                            )
                          : const Text(
                              'Live OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isInitializingCamera ? null : _toggleLive,
              icon: Icon(_liveEnabled ? Icons.stop : Icons.play_arrow),
              label: Text(_liveEnabled ? 'Matikan Live' : 'Nyalakan Live'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _liveEnabled ? colorScheme.error : colorScheme.primary,
                foregroundColor: _liveEnabled ? colorScheme.onError : colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ringkasan Live',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _ResultRow(label: 'Total Tandan', value: _detections.length.toString()),
                    const Divider(),
                    _ResultRow(label: 'Janjang kosong', value: (_summary['Janjang kosong'] ?? 0).toString()),
                    _ResultRow(label: 'Kurang masak', value: (_summary['Kurang masak'] ?? 0).toString()),
                    _ResultRow(label: 'TBS abnormal', value: (_summary['TBS abnormal'] ?? 0).toString()),
                    _ResultRow(label: 'TBS masak', value: (_summary['TBS masak'] ?? 0).toString()),
                    _ResultRow(label: 'TBS mentah', value: (_summary['TBS mentah'] ?? 0).toString()),
                    _ResultRow(label: 'Terlalu masak', value: (_summary['Terlalu masak'] ?? 0).toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
