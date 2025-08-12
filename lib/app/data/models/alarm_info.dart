class AlarmInfo {
  int? id;
  String? title;
  DateTime? dateTime;
  bool? isPending;
  int? gradientColorIndex; // 그라데이션 색상 인덱스

  AlarmInfo({
    this.id,
    this.title,
    this.dateTime,
    this.isPending,
    this.gradientColorIndex,
  });

  factory AlarmInfo.fromMap(Map<String, dynamic> json) {
    return AlarmInfo(
      id: json["id"],
      title: json["title"],
      dateTime: DateTime.parse(json["dateTime"]),
      isPending: json["isPending"],
      gradientColorIndex: json["gradientColorIndex"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "dateTime": dateTime?.toIso8601String(),
      "isPending": isPending,
      "gradientColorIndex": gradientColorIndex,
    };
  }
}
