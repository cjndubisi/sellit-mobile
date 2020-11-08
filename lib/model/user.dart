import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.number,
    this.name,
  });

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      number: map['number'].toString(),
      name: map['name'].toString(),
    );
  }

  final String number;
  final String name;

  @override
  List<Object> get props => [number, name];

  @override
  bool get stringify => true;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name': name,
    };
  }
}
