import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/listing/bloc/bloc.dart';

import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';


class ListItemWidget extends StatelessWidget {
  const ListItemWidget(this._itemEntity);

  final ItemEntity _itemEntity;

  @override
  Widget build(BuildContext context) {
    final ListingBloc listingBloc = BlocProvider.of<ListingBloc>(context);
    return GestureDetector(
      child: Card(
        margin: Spacing.small,
        child: CachedNetworkImage(
          imageUrl: _itemEntity.images[0].toString(),
          placeholder: (BuildContext context, String url) => const Icon(
            Icons.image,
            size: 90,
            color: ColorPalette.white,
          ),
          errorWidget: (BuildContext context, String url, dynamic error) => const Icon(
            Icons.image,
            size: 90,
          ),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: 100,
        ),
      ),
      onTap: () => listingBloc.add(ListItemClickEvent(_itemEntity)),
      behavior: HitTestBehavior.opaque,
    );
  }
}
