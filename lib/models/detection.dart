class Detection {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double score;
  final int classId;
  final String className;

  const Detection({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.score,
    required this.classId,
    required this.className,
  });

  double get width => x2 - x1;
  double get height => y2 - y1;

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'score': score,
      'bbox': [x1, y1, x2, y2],
      'classId': classId,
    };
  }

  factory Detection.fromMap(Map<String, dynamic> map) {
    final bbox = List<num>.from(map['bbox'] ?? [0, 0, 0, 0]);
    return Detection(
      x1: bbox[0].toDouble(),
      y1: bbox[1].toDouble(),
      x2: bbox[2].toDouble(),
      y2: bbox[3].toDouble(),
      score: (map['score'] ?? 0.0).toDouble(),
      classId: map['classId'] ?? 0,
      className: map['className'] ?? '',
    );
  }
}

class DetectionRecord {
  final int id;
  final int userId;
  final int total;
  final String? dominantLabel;
  final Map<String, int> counts;
  final List<Detection> detections;
  final String? imagePath;
  final DateTime createdAt;

  DetectionRecord({
    required this.id,
    required this.userId,
    required this.total,
    this.dominantLabel,
    required this.counts,
    required this.detections,
    this.imagePath,
    required this.createdAt,
  });

  factory DetectionRecord.fromMap(Map<String, dynamic> map) {
    return DetectionRecord(
      id: map['id'],
      userId: map['userId'],
      total: map['total'],
      dominantLabel: map['dominantLabel'],
      counts: Map<String, int>.from(map['counts'] ?? {}),
      detections: (map['detections'] as List? ?? [])
          .map((e) => Detection.fromMap(e))
          .toList(),
      imagePath: map['imagePath'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
