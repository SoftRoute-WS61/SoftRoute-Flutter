class TypeOfComplaint {
  int id;
  String name;
  TypeOfComplaint({required this.id, required this.name});
  factory TypeOfComplaint.fromJson(Map<String, dynamic> json) {
    return TypeOfComplaint(
      id: json['id'],
      name: json['name'],
    );
  }
}