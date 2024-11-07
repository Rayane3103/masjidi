class Machro3 {
  final String name;
 final String date;
 final String location;

  Machro3( {required this.name, required this.date, required this.location});

  factory Machro3.fromJson(Map<String, dynamic> json) {
    return Machro3(
      name: json['name'],
      date: DateTime.parse(json['date']).toString(),
      location: json['location'],
    );
  }
}
