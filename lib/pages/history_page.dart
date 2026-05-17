import 'package:flutter/material.dart';
import '../services/detection_service.dart';
import '../models/detection.dart';
import '../services/api_client.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<DetectionRecord> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);
    final history = await DetectionService.getHistory();
    if (mounted) {
      setState(() {
        _history = history;
        _isLoading = false;
      });
    }
  }

  Future<void> _showDeleteDialog(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Apakah Anda yakin ingin menghapus riwayat deteksi ini secara permanen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await DetectionService.deleteDetection(id);
      if (success) {
        _fetchHistory();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Riwayat berhasil dihapus')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus riwayat')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primaryContainer.withOpacity(0.4), colorScheme.surface],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Deteksi',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Daftar hasil analisis tandan buah segar kelapa sawit Anda',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_rounded, size: 64, color: Colors.grey.withOpacity(0.3)),
                            const SizedBox(height: 16),
                            const Text('Belum ada riwayat', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _history.length,
                        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 24),
                        itemBuilder: (context, index) {
                          final item = _history[index];
                          final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(item.createdAt.toLocal());

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: item.imagePath != null
                                          ? Image.network(
                                              item.imagePath!.startsWith('http')
                                                  ? item.imagePath!
                                                  : '${ApiClient.baseUrl.replaceAll('/api', '')}${item.imagePath}',
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Center(
                                                child: Text(
                                                  item.total.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Theme.of(context).colorScheme.primary,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                item.total.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.dominantLabel ?? 'Tanpa Label',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formattedDate,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline_rounded, color: Colors.red.withOpacity(0.7)),
                                    onPressed: () => _showDeleteDialog(item.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),  
        ],
      ),
    );
  }
}
