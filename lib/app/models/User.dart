import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/models/Role.dart';

class User {
  bool auth;
  String id;
  final String password;
  final String username;
  String email;
  final Timestamp creation_date;
  final Timestamp last_login;
  Role role;

  User(
      {this.password,
      this.username,
      this.email,
      this.creation_date,
      this.last_login,
      this.role,
      this.id});

  User.fromFire(fire)
      : username = fire['username'],
        password = fire['password'],
        email = fire['email'],
        creation_date = fire['creation_date'],
        id = null,
        last_login = fire['last_login'];

  printUser() {
    print(this.id);
    print(this.password);
    print(this.username);
    print(this.email);
    print(this.creation_date);
    print(this.last_login);
    // this.role.printRole();
  }

  Map<String, dynamic> tofire() => {
        'username': username,
        'email': email,
        'password': password,
        'creation_date': creation_date,
        'last_login': last_login,
      };
}
