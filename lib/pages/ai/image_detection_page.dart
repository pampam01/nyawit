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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 340,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Center(
                  child: _isProcessing
                      ? const CircularProgressIndicator()
                      : _image != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(_image!, fit: BoxFit.cover),
                                CustomPaint(
                                  painter: DetectionBoxPainter(_detections),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined, size: 64, color: colorScheme.primary.withOpacity(0.2)),
                                const SizedBox(height: 12),
                                Text('Pilih gambar untuk dianalisis', style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6))),
                              ],
                            ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isProcessing ? null : () => _processImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_rounded, size: 20),
                    label: const Text('Kamera'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _isProcessing ? null : () => _processImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded, size: 20),
                    label: const Text('Galeri'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Hasil Analisis',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.green.withOpacity(0.1)),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _ResultRow(
                    label: 'Total Tandan', 
                    value: _detections.length.toString(),
                    isBold: true,
                    color: colorScheme.primary,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(height: 1),
                  ),
                  _buildDetailedResults(),
                ],
              ),
            ),
            if (_detections.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveResults,
                  icon: _isSaving 
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.cloud_upload_outlined),
                  label: const Text('Simpan ke Riwayat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedResults() {
    final List<String> labels = [
      'TBS masak', 'TBS mentah', 'Kurang masak', 'Terlalu masak', 'Janjang kosong', 'TBS abnormal'
    ];
    
    return Column(
      children: labels.map((label) {
        final count = _summary[label] ?? 0;
        if (count == 0 && _detections.isNotEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: _ResultRow(label: label, value: count.toString()),
        );
      }).toList(),
    );
  }

}


class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _ResultRow({
    required this.label, 
    required this.value, 
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: isBold ? 16 : 14,
              color: color,
            )
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
