import 'dart:ffi';

class Book {
  String bookName;
  int numberOfPart;
  String bookClass; 
  String Creator;
  String detecteur;
  String DarNacher;
  String DateOfPublier;
  String Country;
  Bool interdit;


  Book({
    required this.bookName,
    required this.numberOfPart,
    required this.bookClass,
    required this.Creator,
    required this.detecteur,
    required this.DarNacher,
    required this.DateOfPublier,
    required this.Country,
    required this.interdit,
  });
factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookName: json['bookName'],
      numberOfPart: json['numberOfPart'],
      bookClass: json['bookClass'],
      Creator: json['Creator'],
      detecteur: json['detecteur'],
      DarNacher: json['DarNacher'],
      DateOfPublier: json['DateOfPublier'],
      Country: json['Country'],
      interdit: json['interdit'],    
    );
  }
  
}
