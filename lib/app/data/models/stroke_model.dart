class StrokePoint {
  final double x;
  final double y;

  StrokePoint({required this.x, required this.y});

  factory StrokePoint.fromJson(Map<String, dynamic> json) {
    return StrokePoint(x: json['x'].toDouble(), y: json['y'].toDouble());
  }
}

class StrokeData {
  final StrokePoint start;
  final StrokePoint end;

  StrokeData({required this.start, required this.end});

  factory StrokeData.fromJson(Map<String, dynamic> json) {
    return StrokeData(
      start: StrokePoint.fromJson(json['start']),
      end: StrokePoint.fromJson(json['end']),
    );
  }
}
