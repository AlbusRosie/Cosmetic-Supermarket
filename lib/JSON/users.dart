import 'dart:convert';

Users userFromJson(String str) => Users.fromMap(json.decode(str));

String userToJson(Users data) => json.encode(data.toMap());

class Users {
  final int? uid;
  final String? urole;
  final String? uname;
  final String phone;
  final String password;
  final String? address;
  final String? avt; // Optional avatar field

  Users({
    this.uid,
    this.urole = "2",
    this.uname,
    required this.phone,
    required this.password,
    this.address,
    this.avt,
  });

  // The json value must be the same as the column name in database
  factory Users.fromMap(Map<String, dynamic> json) => Users(
        uid: json["uid"], // Added uid
        urole: json["urole"] ?? "2", // Default to "customer"
        uname: json["uname"],
        phone: json["phone"],
        password: json["password"],
        address: json["address"],
        avt: json["avt"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "urole": urole,
        "uname": uname,
        "phone": phone,
        "password": password,
        "address": address,
        "avt": avt,
      };
}
