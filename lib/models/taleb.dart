class Taleb {
  final String name;
  final String dateDeNaissance;
  final String placeDeNaissance;
  final String hzb;

  Taleb({
    required this.name,
    required this.dateDeNaissance,
    required this.placeDeNaissance,
    required this.hzb,
  });

  factory Taleb.fromJson(Map<String, dynamic> json) {
    try {
      return Taleb(
        name: json['name'] ?? '',
        dateDeNaissance: json['dateDeNaissance']?.toString() ?? '',  // Use string directly
        placeDeNaissance: json['placeDeNaissance'] ?? '',
        hzb: json['hzb']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing Taleb: $e');
      return Taleb(
        name: '',
        dateDeNaissance: '',
        placeDeNaissance: '',
        hzb: '',
      );
    }
  }
}
