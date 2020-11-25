import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/utility.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListItemWidget extends StatelessWidget {
  const UserListItemWidget(this._itemEntity, this.navigate);
  final ItemEntity _itemEntity;
  final Future Function(ItemEntity) navigate;

  @override
  Widget build(BuildContext context) {
    final _utilityProvider = context.read<UtilityProvider>();
    return InkWell(
      child: Stack(children: [
        Card(
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
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.fiber_manual_record,
              color: _utilityProvider.getColor(_itemEntity.state),
            ),
          ),
        ),
      ]),
      onTap: () => navigate(_itemEntity),
    );
  }
}
