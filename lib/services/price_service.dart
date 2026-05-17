import 'dart:convert';
import 'api_client.dart';

class PalmPriceData {
  final String date;
  final int averagePrice;
  final String trend;
  final String trendPercent;
  final String note;
  final Map<String, int> byAge;
  final Map<String, int> byRegion;

  PalmPriceData({
    required this.date,
    required this.averagePrice,
    required this.trend,
    required this.trendPercent,
    required this.note,
    required this.byAge,
    required this.byRegion,
  });

  factory PalmPriceData.fromMap(Map<String, dynamic> map) {
    return PalmPriceData(
      date: map['date'] ?? '',
      averagePrice: map['averagePrice'] ?? 0,
      trend: map['trend'] ?? 'up',
      trendPercent: map['trendPercent'] ?? '0.00%',
      note: map['note'] ?? '',
      byAge: Map<String, int>.from(map['byAge'] ?? {}),
      byRegion: Map<String, int>.from(map['byRegion'] ?? {}),
    );
  }
}

class PriceService {
  static Future<PalmPriceData?> getTodayPrices() async {
    try {
      final response = await ApiClient.get('/prices/today');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success' && body['data'] != null) {
          return PalmPriceData.fromMap(body['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching palm prices: $e');
      return null;
    }
  }
}
