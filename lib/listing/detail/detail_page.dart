import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/listing/bloc/bloc.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class DetailPage extends StatelessWidget {
  const DetailPage();

  @override
  Widget build(BuildContext context) {
    final _controller = SolidController();
    final _listingBloc = BlocProvider.of<ListingBloc>(context);
    final _itemEntity = (_listingBloc.state as NavigateToDetail).itemEntity;
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
        body: Padding(
          padding: Spacing.fab,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              carousel,
              Text(
                _itemEntity.description,
                style: style,
              ),
              Divider(),
              Sizing.medium,
              Row(
                children: [
                  Icon(Icons.account_balance_wallet),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    'NGN ${_itemEntity.price}',
                    style: style,
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Icon(Icons.location_on),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    _itemEntity.location,
                    style: style,
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Icon(Icons.person),
                  Spacer(),
                  Text(
                    _itemEntity.author.displayName ?? _itemEntity.author.name,
                    style: style,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              FlatButton(
                onPressed: () => _controller.isOpened ? _controller.hide() : _controller.show(),
                child: Text(
                  'Contact Seller',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
              )
            ],
          ),
        ),
        bottomSheet: SolidBottomSheet(
          controller: _controller,
          maxHeight: 100,
          headerBar: Container(
            height: 10,
            width: 10,
          ),
          body: Container(
            child: Wrap(
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            onPressed: () => _listingBloc.add(ContactSellerEvent(
                              ContactSellerType.whatsapp,
                              _itemEntity,
                            )),
                            child: Text(
                              'whatsapp',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          FlatButton(
                            onPressed: () => _listingBloc.add(ContactSellerEvent(
                              ContactSellerType.sms,
                              _itemEntity,
                            )),
                            child: Text(
                              'sms',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
