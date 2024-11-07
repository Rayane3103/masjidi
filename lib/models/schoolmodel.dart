class School {
  final String mosqueId;
  final String mosqueName;
  final String teacherName;
  final String madrassaType;
  final Map<String, String?> timeSlot;

  School({
    required this.mosqueId,
    required this.mosqueName,
    required this.teacherName,
    required this.madrassaType,
    required this.timeSlot,
  });

  @override
  String toString() {
    return 'School(mosqueId: $mosqueId, mosqueName: $mosqueName, teacherName: $teacherName, madrassaType: $madrassaType, timeSlot: $timeSlot)';
  }
}
