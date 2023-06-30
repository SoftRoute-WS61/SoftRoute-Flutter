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

  Map<String, dynamic> toMap(){
    return {
      'id':(id==0)? null: id,
      'name':name,
    };
  }
}