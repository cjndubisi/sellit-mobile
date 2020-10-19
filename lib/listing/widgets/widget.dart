import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

class ListingWidget extends StatefulWidget {
  const ListingWidget(this._itemEntity);

  final ItemEntity _itemEntity;

  @override
  _ListingWidget createState() => _ListingWidget();
}

class _ListingWidget extends State<ListingWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: Spacing.small,
      child: CachedNetworkImage(
        imageUrl: widget._itemEntity.images[0].toString(),
        placeholder: (BuildContext context, String url) => const Icon(
          Icons.image,
          size: 90,
          color: Colors.white,
        ),
        errorWidget: (BuildContext context, String url, dynamic error) => const Icon(
          Icons.image,
          size: 90,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
