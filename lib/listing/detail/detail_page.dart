import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/listing/bloc/bloc.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  ItemEntity _itemEntity;

  ListingBloc _listingBloc;

  @override
  void initState() {
    super.initState();
    _listingBloc = BlocProvider.of<ListingBloc>(context);
    _itemEntity = _listingBloc.itemEntity;
  }

  @override
  Widget build(BuildContext context) {
    final carousel = CarouselSlider.builder(
        itemCount: _itemEntity.images.length,
        itemBuilder: (BuildContext context, int index) => Container(
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: _itemEntity.images[index].toString(),
              placeholder: (BuildContext context, String url) => const Icon(
                Icons.image,
                size: 90,
                color: Colors.white,
              ),
              errorWidget: (BuildContext context, String url, dynamic error) =>
                  const Icon(
                Icons.image,
                size: 90,
              ),
              fit: BoxFit.cover,
            )),
        options: CarouselOptions(
          height: 200,
          enableInfiniteScroll: true,
          enlargeCenterPage: false,
          autoPlay: true,
        ));
    return BlocListener<ListingBloc, ListingState>(
      listener: (BuildContext context, ListingState state) async {},
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _itemEntity.title,
            style: style,
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            carousel,
            Padding(
              padding: Spacing.fab,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _itemEntity.description,
                    style: style,
                  ),
                  const Divider(),
                  Sizing.medium,
                  Row(
                    children: [
                      const Icon(Icons.account_balance_wallet),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        'NGN ${_itemEntity.price}',
                        style: style,
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        _itemEntity.location,
                        style: style,
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.person),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        _itemEntity.author,
                        style: style,
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        _itemEntity.dateCreated,
                        style: style,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
