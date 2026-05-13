import 'package:flutter/material.dart';
import '../models/detection.dart';

class DetectionBoxPainter extends CustomPainter {
  final List<Detection> detections;

  DetectionBoxPainter(this.detections);

  @override
  void paint(Canvas canvas, Size size) {
    for (var det in detections) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = _getColorForClass(det.classId);

      // Konversi koordinat (asumsi det.x1 dll bernilai 0..1)
      final rect = Rect.fromLTRB(
        det.x1 * size.width,
        det.y1 * size.height,
        det.x2 * size.width,
        det.y2 * size.height,
      );

      canvas.drawRect(rect, paint);

      // Gambar label text
      final textSpan = TextSpan(
        text: '${det.className} ${(det.score * 100).toStringAsFixed(0)}%',
        style: TextStyle(
          color: Colors.white,
          backgroundColor: paint.color.withOpacity(0.8),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(rect.left, rect.top - textPainter.height),
      );
    }
  }

  Color _getColorForClass(int classId) {
    switch (classId) {
      case 0: return Colors.grey; // Janjang kosong
      case 1: return Colors.orange; // Kurang masak
      case 2: return Colors.redAccent; // TBS abnormal
      case 3: return Colors.green; // TBS masak
      case 4: return Colors.yellow; // TBS mentah
      case 5: return Colors.deepOrange; // Terlalu masak
      default: return Colors.blue;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
