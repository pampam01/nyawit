import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/price_service.dart';
import '../services/api_client.dart';
import 'auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PalmPriceData? _priceData;
  bool _isLoadingPrice = true;
  bool _showRegionalPrices = false;

  @override
  void initState() {
    super.initState();
    _fetchTodayPrices();
  }

  Future<void> _fetchTodayPrices() async {
    setState(() => _isLoadingPrice = true);
    final data = await PriceService.getTodayPrices();
    if (mounted) {
      setState(() {
        _priceData = data;
        _isLoadingPrice = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Welcome Card dengan Avatar Dinamis
          FutureBuilder<Map<String, dynamic>?>(
              future: AuthService.getMe(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                final name = user?['name'] ?? 'User';
                final email = user?['email'] ?? 'user@nyawit.com';
                final photo = user?['photoProfile'];

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        _buildAvatarWidget(photo, name, 72),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang,',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

          const SizedBox(height: 28),

          // 2. Premium Price Card (Harga Sawit Hari Ini)
          _buildTodayPriceCard(colorScheme),

          const SizedBox(height: 32),

          // 3. Fitur Utama
          Text(
            'Fitur Utama',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  context,
                  icon: Icons.image_search_rounded,
                  title: 'Deteksi Gambar',
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFeatureCard(
                  context,
                  icon: Icons.videocam_rounded,
                  title: 'Deteksi Live',
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Keluar dari Akun'),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayPriceCard(ColorScheme colorScheme) {
    if (_isLoadingPrice) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat harga sawit hari ini...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      );
    }

    if (_priceData == null) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              const Text('Gagal memuat harga sawit harian.', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _fetchTodayPrices,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final data = _priceData!;
    final isUp = data.trend == 'up';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card harga
            Row(
              children: [
                Icon(Icons.monetization_on_outlined, color: colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Harga TBS Sawit Nasional',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                    ),
                  ),
                ),
                Text(
                  data.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Harga Utama & Badge Trend
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Rp ${data.averagePrice}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '/ kg',
                  style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isUp ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUp ? Colors.green.shade200 : Colors.red.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isUp ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 14,
                        color: isUp ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data.trendPercent,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isUp ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Rekomendasi/Catatan Pasar (Alert Box)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.primary.withOpacity(0.08)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.note,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontStyle: FontStyle.italic,
                        color: colorScheme.primary.withOpacity(0.85),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Expandable List Harga Regional / Daerah
            InkWell(
              onTap: () {
                setState(() {
                  _showRegionalPrices = !_showRegionalPrices;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lihat Rincian Wilayah & Umur',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: colorScheme.primary,
                      ),
                    ),
                    Icon(
                      _showRegionalPrices ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),

            if (_showRegionalPrices) ...[
              const SizedBox(height: 12),
              const Text(
                'Berdasarkan Umur Pohon:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              ...data.byAge.entries.map((e) => _buildPriceRow(e.key, e.value)),
              const Divider(height: 24),
              const Text(
                'Berdasarkan Daerah (Benchmark):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              ...data.byRegion.entries.map((e) => _buildPriceRow(e.key, e.value)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, int price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500)),
          Text('Rp $price / kg', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAvatarWidget(String? photoProfile, String name, double size) {
    if (photoProfile != null) {
      if (photoProfile.startsWith('preset_')) {
        IconData icon;
        Color bg;
        switch (photoProfile) {
          case 'preset_leaf':
            icon = Icons.spa_rounded;
            bg = Colors.teal.shade100;
            break;
          case 'preset_seedling':
            icon = Icons.yard_rounded;
            bg = Colors.lightGreen.shade100;
            break;
          case 'preset_palm':
            icon = Icons.nature_people_rounded;
            bg = Colors.green.shade100;
            break;
          case 'preset_farmer':
            icon = Icons.face_retouching_natural_rounded;
            bg = Colors.orange.shade100;
            break;
          default:
            icon = Icons.person_rounded;
            bg = Colors.white.withOpacity(0.2);
        }
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: size * 0.5, color: Colors.green.shade900),
        );
      }

      if (photoProfile.startsWith('/uploads') || photoProfile.startsWith('http')) {
        final imageUrl = photoProfile.startsWith('http')
            ? photoProfile
            : '${ApiClient.baseUrl.replaceAll('/api', '')}$photoProfile';
        return ClipOval(
          child: Image.network(
            imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(name, size),
          ),
        );
      }

      try {
        final cleanBase64 = photoProfile.contains(',') ? photoProfile.split(',')[1] : photoProfile;
        final decodedBytes = base64Decode(cleanBase64.trim());
        return ClipOval(
          child: Image.memory(
            decodedBytes,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(name, size),
          ),
        );
      } catch (e) {
        return _buildDefaultAvatar(name, size);
      }
    }
    return _buildDefaultAvatar(name, size);
  }

  Widget _buildDefaultAvatar(String name, double size) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required ColorScheme colorScheme,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
