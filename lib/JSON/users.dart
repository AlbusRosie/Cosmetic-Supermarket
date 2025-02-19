import 'dart:convert';

User userFromJson(String str) => User.fromMap(json.decode(str));

String userToJson(User data) => json.encode(data.toMap());

class User {
  final int? uid;
  final String urole;
  final String uname;
  final String? email;
  final String? phone;
  final String password;
  final String address;
  final String? avt; // Optional avatar field

  User({
    this.uid,
    required this.urole,
    required this.uname,
    this.email,
    this.phone,
    required this.password,
    required this.address,
    this.avt,
  });

  // The json value must be the same as the column name in database
  factory User.fromMap(Map<String, dynamic> json) => User(
        uid: json["uid"], // Added uid
        urole: json["urole"] ?? "customer", // Default to "customer"
        uname: json["uname"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        address: json["address"],
        avt: json["avt"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "urole": urole,
        "uname": uname,
        "email": email,
        "phone": phone,
        "password": password,
        "address": address,
        "avt": avt,
      };
}
