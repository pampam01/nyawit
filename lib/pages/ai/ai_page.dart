import 'package:flutter/material.dart';
import 'image_detection_page.dart';
import 'live_detection_page.dart';

class AiPage extends StatelessWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      children: [
        Text(
          'Pilih Mode Deteksi',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pilih cara Anda mendeteksi kematangan sawit.',
          style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
        ),
        const SizedBox(height: 24),
        _buildModeCard(
          context,
          icon: Icons.image_search_rounded,
          title: 'Deteksi Gambar',
          description: 'Analisis foto dari galeri atau jepretan kamera.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ImageDetectionPage())),
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _buildModeCard(
          context,
          icon: Icons.videocam_rounded,
          title: 'Deteksi Live',
          description: 'Analisis langsung secara real-time lewat kamera.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveDetectionPage())),
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: colorScheme.primary),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colorScheme.primary.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
