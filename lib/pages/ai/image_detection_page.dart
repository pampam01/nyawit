import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/palm_detector.dart';
import '../../models/detection.dart';
import '../../utils/box_painter.dart';
import '../../services/detection_service.dart';

class ImageDetectionPage extends StatefulWidget {
  const ImageDetectionPage({super.key});

  @override
  State<ImageDetectionPage> createState() => _ImageDetectionPageState();
}

class _ImageDetectionPageState extends State<ImageDetectionPage> {
  bool _isProcessing = false;
  bool _isSaving = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final PalmDetector _detector = PalmDetector();
  List<Detection> _detections = [];
  Map<String, int> _summary = {};

  @override
  void initState() {
    super.initState();
    _detector.load();
  }

  @override
  void dispose() {
    _detector.close();
    super.dispose();
  }

  void _processImage(ImageSource source) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _detections = [];
          _summary = {};
        });
        
        final detections = await _detector.detectFromImagePath(pickedFile.path);
        
        if (!mounted) return;
        setState(() {
          _detections = detections;
          _summary = _detector.summarize(detections);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selesai diproses. Ditemukan ${_detections.length} objek.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses gambar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _saveResults() async {
    if (_detections.isEmpty) return;
    
    setState(() => _isSaving = true);
    
    String? dominant;
    int maxCount = -1;
    _summary.forEach((key, value) {
      if (value > maxCount) {
        maxCount = value;
        dominant = key;
      }
    });

    final success = await DetectionService.saveDetection(
      total: _detections.length,
      dominantLabel: dominant,
      counts: _summary,
      detections: _detections,
      imagePath: _image?.path,
    );
    
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Riwayat disimpan' : 'Gagal menyimpan riwayat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deteksi Lewat Gambar'),
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
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: _isProcessing
                      ? const CircularProgressIndicator()
                      : _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(_image!, fit: BoxFit.cover),
                                  CustomPaint(
                                    painter: DetectionBoxPainter(_detections),
                                  ),
                                ],
                              ),
                            )
                          : Icon(
                              Icons.image,
                              size: 100,
                              color: colorScheme.onSurfaceVariant,
                            ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : () => _processImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Ambil Foto'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isProcessing ? null : () => _processImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galeri'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Hasil Deteksi',
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
            if (_detections.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveResults,
                  icon: _isSaving 
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save),
                  label: const Text('Simpan Riwayat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondaryContainer,
                    foregroundColor: colorScheme.onSecondaryContainer,
                    minimumSize: const Size(double.infinity, 48),
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
