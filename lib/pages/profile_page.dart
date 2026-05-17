import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    final user = await AuthService.getMe();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi Nyawit?'),
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
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  Widget _buildAvatarWidget(String? photoProfile, String name, double size) {
    final colorScheme = Theme.of(context).colorScheme;

    if (photoProfile != null) {
      // 1. Check if preset avatar
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
            bg = colorScheme.primaryContainer;
        }
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.primary.withOpacity(0.2), width: 2),
          ),
          child: Icon(icon, size: size * 0.5, color: colorScheme.primary),
        );
      }

      // 2. Check if network static image from backend
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
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultAvatar(name, size);
            },
          ),
        );
      }

      // 3. Custom Base64 Image
      try {
        final cleanBase64 = photoProfile.contains(',') ? photoProfile.split(',')[1] : photoProfile;
        final decodedBytes = base64Decode(cleanBase64.trim());
        return ClipOval(
          child: Image.memory(
            decodedBytes,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultAvatar(name, size);
            },
          ),
        );
      } catch (e) {
        // Fallback on error
        return _buildDefaultAvatar(name, size);
      }
    }

    return _buildDefaultAvatar(name, size);
  }

  Widget _buildDefaultAvatar(String name, double size) {
    final colorScheme = Theme.of(context).colorScheme;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showEditProfileSheet() {
    final nameController = TextEditingController(text: _user?['name']);
    final nicknameController = TextEditingController(text: _user?['nickname'] ?? '');
    String? selectedPhoto = _user?['photoProfile'];
    bool isUpdating = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Ubah Profil Akun',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Stack(
                        children: [
                          _buildAvatarWidget(selectedPhoto, nameController.text, 100),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                                onPressed: () async {
                                  _showPhotoOptions(
                                    onPresetSelected: (preset) {
                                      setSheetState(() => selectedPhoto = preset);
                                    },
                                    onCustomPhotoSelected: (base64Str) {
                                      setSheetState(() => selectedPhoto = base64Str);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nicknameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Panggilan',
                        prefixIcon: const Icon(Icons.alternate_email_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: isUpdating
                          ? null
                          : () async {
                              setSheetState(() => isUpdating = true);
                              final success = await AuthService.updateProfile(
                                name: nameController.text.trim(),
                                nickname: nicknameController.text.trim().isEmpty
                                    ? null
                                    : nicknameController.text.trim(),
                                photoProfile: selectedPhoto,
                              );
                              setSheetState(() => isUpdating = false);

                              if (success) {
                                _fetchProfile();
                                if (mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Profil berhasil diperbarui')),
                                  );
                                }
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Gagal memperbarui profil')),
                                  );
                                }
                              }
                            },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isUpdating
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Simpan Perubahan'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPhotoOptions({
    required Function(String) onPresetSelected,
    required Function(String) onCustomPhotoSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pilih Sumber Foto',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSourceButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Galeri',
                    onTap: () async {
                      Navigator.pop(context);
                      final picker = ImagePicker();
                      final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
                      if (image != null) {
                        final bytes = await image.readAsBytes();
                        final base64Str = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                        onCustomPhotoSelected(base64Str);
                      }
                    },
                  ),
                  _buildSourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Kamera',
                    onTap: () async {
                      Navigator.pop(context);
                      final picker = ImagePicker();
                      final image = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
                      if (image != null) {
                        final bytes = await image.readAsBytes();
                        final base64Str = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                        onCustomPhotoSelected(base64Str);
                      }
                    },
                  ),
                ],
              ),
              const Divider(height: 32),
              Text(
                'Pilih Preset Avatar Premium',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildPresetAvatarOption('preset_leaf', Icons.spa_rounded, Colors.teal.shade100, onPresetSelected),
                    _buildPresetAvatarOption('preset_seedling', Icons.yard_rounded, Colors.lightGreen.shade100, onPresetSelected),
                    _buildPresetAvatarOption('preset_palm', Icons.nature_people_rounded, Colors.green.shade100, onPresetSelected),
                    _buildPresetAvatarOption('preset_farmer', Icons.face_retouching_natural_rounded, Colors.orange.shade100, onPresetSelected),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPresetAvatarOption(String presetId, IconData icon, Color bg, Function(String) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: () {
          onSelected(presetId);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), width: 1.5),
          ),
          child: Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildSourceButton({required IconData icon, required String label, required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordSheet() {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isUpdating = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Ganti Password Akun',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password Baru',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Password Baru',
                        prefixIcon: const Icon(Icons.lock_reset_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: isUpdating
                          ? null
                          : () async {
                              final password = passwordController.text.trim();
                              final confirm = confirmPasswordController.text.trim();

                              if (password.isEmpty || confirm.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Semua field harus diisi')),
                                );
                                return;
                              }

                              if (password.length < 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Password minimal terdiri dari 6 karakter')),
                                );
                                return;
                              }

                              if (password != confirm) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Konfirmasi password tidak cocok')),
                                );
                                return;
                              }

                              setSheetState(() => isUpdating = true);
                              final success = await AuthService.updateProfile(password: password);
                              setSheetState(() => isUpdating = false);

                              if (success) {
                                if (mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Password berhasil diganti')),
                                  );
                                }
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Gagal mengganti password')),
                                  );
                                }
                              }
                            },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isUpdating
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Ganti Password'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = _user?['name'] ?? 'User';
    final email = _user?['email'] ?? 'user@nyawit.com';
    final nickname = _user?['nickname'] ?? '-';
    final photo = _user?['photoProfile'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Gradient Premium
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primaryContainer.withOpacity(0.6), colorScheme.surface],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 64, 24, 40),
              child: Column(
                children: [
                  _buildAvatarWidget(photo, name, 110),
                  const SizedBox(height: 20),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    email,
                    style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.8), fontSize: 15),
                  ),
                  if (_user?['nickname'] != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '@$nickname',
                        style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Profile Actions List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Column(
                      children: [
                        _buildProfileTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Ubah Data Profil',
                          subtitle: 'Ganti nama lengkap, panggilan, dan foto',
                          onTap: _showEditProfileSheet,
                        ),
                        Divider(indent: 64, height: 1, color: colorScheme.outlineVariant.withOpacity(0.5)),
                        _buildProfileTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Ganti Password',
                          subtitle: 'Perbarui kata sandi keamanan Anda',
                          onTap: _showChangePasswordSheet,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: _buildProfileTile(
                      icon: Icons.logout_rounded,
                      title: 'Keluar Akun',
                      subtitle: 'Selesaikan sesi Anda di aplikasi Nyawit',
                      iconColor: colorScheme.error,
                      textColor: colorScheme.error,
                      onTap: _logout,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final finalIconColor = iconColor ?? colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: finalIconColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: finalIconColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colorScheme.onSurfaceVariant.withOpacity(0.4),
      ),
      onTap: onTap,
    );
  }
}
