import 'package:flutter/material.dart';

class ImageDetectionPage extends StatefulWidget {
  const ImageDetectionPage({super.key});

  @override
  State<ImageDetectionPage> createState() => _ImageDetectionPageState();
}

class _ImageDetectionPageState extends State<ImageDetectionPage> {
  bool _isProcessing = false;

  @override
  void dispose() {
    // Nanti dispose controller TFLite / hal lain di sini agar tidak membebani memori
    super.dispose();
  }

  void _processImage(String source) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Simulasi proses async
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mengambil gambar dari $source (Placeholder)')),
    );
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
                    onPressed: _isProcessing ? null : () => _processImage('Kamera'),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Ambil Foto'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isProcessing ? null : () => _processImage('Galeri'),
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
                  children: const [
                    _ResultRow(label: 'Total Tandan', value: '-'),
                    Divider(),
                    _ResultRow(label: 'Janjang kosong', value: '-'),
                    _ResultRow(label: 'Kurang masak', value: '-'),
                    _ResultRow(label: 'TBS abnormal', value: '-'),
                    _ResultRow(label: 'TBS masak', value: '-'),
                    _ResultRow(label: 'TBS mentah', value: '-'),
                    _ResultRow(label: 'Terlalu masak', value: '-'),
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
