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
}
