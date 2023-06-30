class Admin{
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String password;
  final int phoneNumber;
  final String code;

  Admin({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.code
  });

  Map<String,dynamic> toMap(){
    return {
      'id':(id==0)? null: id,
      'name':name,
      'lastName':lastName,
      'email':email,
      'password':password,
      'phoneNumber':phoneNumber,
      'code':code
    };
  }

}