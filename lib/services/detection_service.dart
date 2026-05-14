import 'dart:convert';
import '../models/detection.dart';
import 'api_client.dart';

class DetectionService {
  static Future<bool> saveDetection({
    required int total,
    required String? dominantLabel,
    required Map<String, int> counts,
    required List<Detection> detections,
    String? imagePath,
  }) async {
    try {
      final response = await ApiClient.post('/detections', {
        'total': total,
        'dominantLabel': dominantLabel,
        'counts': counts,
        'detections': detections.map((e) => e.toMap()).toList(),
        'imagePath': imagePath,
      });

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<List<DetectionRecord>> getHistory() async {
    try {
      final response = await ApiClient.get('/detections');
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['detections'];
        return data.map((e) => DetectionRecord.fromMap(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> deleteDetection(int id) async {
    try {
      final response = await ApiClient.delete('/detections/$id');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
