import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

class AuthService {
  static Future<bool> register(String name, String email, String password) async {
    try {
      final response = await ApiClient.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final response = await ApiClient.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<Map<String, dynamic>?> getMe() async {
    try {
      final response = await ApiClient.get('/auth/me');
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['user'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateProfile({
    String? name,
    String? nickname,
    String? password,
    String? photoProfile,
  }) async {
    try {
      final response = await ApiClient.put('/auth/update-profile', {
        if (name != null) 'name': name,
        if (nickname != null) 'nickname': nickname,
        if (password != null) 'password': password,
        if (photoProfile != null) 'photoProfile': photoProfile,
      });

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
