import 'package:flutter_starterkit_firebase/model/user.dart';

class ItemEntity {
  const ItemEntity(
    this.id,
    this.author,
    this.title,
    this.description,
    this.price,
    this.location,
    this.type,
    this.dateCreated,
    this.images,
  );

  ItemEntity.fromJson(Map<String, dynamic> json)
      : id = json['_uid'].toString(),
        author = User(name:json['author'].toString() , number: 'fsdfasd'),
        title = json['title'].toString(),
        description = json['description'].toString(),
        price = double.parse(json['price'].toString()),
        location = json['location'].toString(),
        type = json['type'].toString(),
        dateCreated = json['dateCreated'].toString(),
        images = json['images'] as List<dynamic>;

  final String id;
  final User author;
  final String title;
  final String description;
  final double price;
  final String location;
  final String type;
  final String dateCreated;
  final List<dynamic> images;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'type': type,
      'dateCreated': dateCreated,
      'images': images,
    };
  }
}
