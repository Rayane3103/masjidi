class Employee {
  final String name;
  final String contact;
  final String dateOfstart;
  final String role;
  final String taklif;

  Employee({
    required this.name,
    required this.contact,
    required this.dateOfstart,
    required this.role,
    required this.taklif,
  });

  Map<String, dynamic> toMap() {
  return {
    'name': name,
    'contact': contact,
    'dateOfstart': dateOfstart,
    'role': role.isNotEmpty ? role : null,  // Pass null if empty
    'taklif': taklif.isNotEmpty ? taklif : null,  // Pass null if empty
  };
}

}
