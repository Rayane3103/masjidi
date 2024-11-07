class Tabaro3 {
 final int somme;
 final String date;
 final String machro3;
 final String mailer;
 final String mailerId;

  Tabaro3({required this.somme, required this.date, required this.machro3,required this.mailer, required this.mailerId });

  factory Tabaro3.fromJson(Map<String, dynamic> json) {
    return Tabaro3(
      somme: json['somme'],
      date: DateTime.parse(json['date']).toString(),
      machro3: json['machro3'],
      mailer: json['mailer'], 
      mailerId: json['mailerId'],     
    );
  }
}