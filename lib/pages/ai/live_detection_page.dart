import 'package:flutter/material.dart';

class LiveDetectionPage extends StatefulWidget {
  const LiveDetectionPage({super.key});

  @override
  State<LiveDetectionPage> createState() => _LiveDetectionPageState();
}

class _LiveDetectionPageState extends State<LiveDetectionPage> {
  bool _liveEnabled = false;
  bool _isInitializingCamera = false;
  bool _isDetecting = false;

  @override
  void dispose() {
    // PENTING: Matikan live saat keluar
    _stopLive();
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

    // Simulasi inisialisasi kamera
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isInitializingCamera = false;
      _liveEnabled = true;
      _isDetecting = true;
    });
  }

  void _stopLive() {
    if (!mounted) return;
    
    setState(() {
      _liveEnabled = false;
      _isDetecting = false;
    });
    
    // Nanti stopImageStream dan dispose CameraController di sini
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
                      : Text(
                          _liveEnabled ? 'Live ON (Placeholder)' : 'Live OFF',
                          style: const TextStyle(
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
