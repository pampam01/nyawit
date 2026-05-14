import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Ganti IP ini dengan IP laptop Anda jika menggunakan HP fisik via WiFi
  // Jika menggunakan ADB Reverse (USB) atau Emulator, gunakan 127.0.0.1 atau 10.0.2.2
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');
    
    print('ApiClient POST: $url');
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      print('ApiClient Response [${response.statusCode}]: ${response.body}');
      return response;
    } catch (e) {
      print('ApiClient Error: $e');
      rethrow;
    }
  }

  static Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');
    
    print('ApiClient GET: $url');
    try {
      final response = await http.get(url, headers: headers);
      print('ApiClient Response [${response.statusCode}]: ${response.body}');
      return response;
    } catch (e) {
      print('ApiClient Error: $e');
      rethrow;
    }
  }

  static Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');
    
    print('ApiClient DELETE: $url');
    try {
      final response = await http.delete(url, headers: headers);
      print('ApiClient Response [${response.statusCode}]: ${response.body}');
      return response;
    } catch (e) {
      print('ApiClient Error: $e');
      rethrow;
    }
  }
}
