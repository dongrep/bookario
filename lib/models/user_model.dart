class UserModel {
  final String? id;
  final String name;
  final String phone;
  final String email;
  final String age;
  final String gender;

  UserModel(
      {this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.age,
      required this.gender});

  UserModel.fromJson(Map<String, dynamic> json, this.id)
      : name = json['name'] as String,
        phone = json['phone'] as String,
        email = json['email'] as String,
        age = json['age'] as String,
        gender = json['gender'] as String;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "email": email,
      "age": age,
      "gender": gender
    };
  }
}
