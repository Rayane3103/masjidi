class Pub {
  final String? title;
  final String? description;
  final String? file;
  final DateTime? date;

  Pub({this.title, this.description, this.file, this.date});

  factory Pub.fromJson(Map<String, dynamic> json) {
    return Pub(
      title: json['title'] ?? 'No title available',
      description: json['description'] ?? 'No description available',
      file: json['pdf'] ?? '',
      date: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']) // Convert string to DateTime
          : null,
    );
  }
}
