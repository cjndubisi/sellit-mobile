import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/listing/bloc/bloc.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

class DetailPage extends StatelessWidget {
  const DetailPage();

  @override
  Widget build(BuildContext context) {
    final _itemEntity = (BlocProvider.of<ListingBloc>(context).state as NavigateToDetail).itemEntity;
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
          errorWidget: (BuildContext context, String url, dynamic error) => const Icon(
            Icons.image,
            size: 90,
          ),
          fit: BoxFit.cover,
        ),
      ),
      options: CarouselOptions(
        height: 200,
        enableInfiniteScroll: true,
        enlargeCenterPage: false,
        autoPlay: true,
      ),
    );
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
                        _itemEntity.author.name,
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
