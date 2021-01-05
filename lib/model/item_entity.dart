import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/user.dart';

class ItemEntity {
  ItemEntity({
    @required this.author,
    @required this.uid,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.location,
    @required this.type,
    @required this.dateCreated,
    this.images = const [],
  });

  factory ItemEntity.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return ItemEntity(
      author: User.fromJson(map['author'] as Map<String, dynamic>),
      uid: map['uid'].toString(),
      title: map['title'].toString(),
      description: map['description'].toString(),
      price: map['price'] as double,
      location: map['location'].toString(),
      type: map['type'].toString(),
      dateCreated: map['dateCreated'] as int,
      images: List<String>.from(map['images'] as List ?? []),
    );
  }

  final User author;
  final String uid;
  final String title;
  final String description;
  final double price;
  final String location;
  final String type;
  final int dateCreated;
  final List<String> images;

  Map<String, dynamic> toMap() {
    return {
      'author': author.toMap(),
      'uid': uid,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'type': type,
      'dateCreated': dateCreated,
      'images': images,
    };
  }

  ItemEntity copyWith({
    String phoneNumber,
    User author,
    String uid,
    String title,
    String description,
    double price,
    String location,
    String type,
    int dateCreated,
    List<String> images,
  }) {
    return ItemEntity(
      author: author ?? this.author,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      location: location ?? this.location,
      type: type ?? this.type,
      dateCreated: dateCreated ?? this.dateCreated,
      images: images ?? this.images,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ItemEntity(uid: $uid, userName: $author, title: $title, description: $description, price: $price, location: $location, type: $type, dateCreated: $dateCreated, images: $images)';
  }
}
