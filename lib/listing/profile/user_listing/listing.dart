import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/core/navigation_service.dart';
import 'package:flutter_starterkit_firebase/listing/profile/bloc/profile_bloc.dart';
import 'package:flutter_starterkit_firebase/listing/profile/user_listing/buildlist_screen.dart';
import 'package:flutter_starterkit_firebase/utils/constants.dart';

class UserItemsListing extends StatefulWidget {
  UserItemsListing({Key key}) : super(key: key);

  @override
  _UserItemsListingState createState() => _UserItemsListingState();
}

class _UserItemsListingState extends State<UserItemsListing> {
  final List<Widget> tabBarViews = [];
  @override
  Widget build(BuildContext context) {
    final _navigationService = context.repository<NavigationService>();
    final ProfileBloc _profileBloc = context.bloc<ProfileBloc>();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('My Listings'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Live'),
              Tab(text: 'Sold'),
              Tab(text: 'Draft'),
            ],
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ProfileErrorState) {
                return Center(child: Text('An error occured'));
              }
              return TabBarView(
                children: [
                  BuildList(
                    stream: _profileBloc.getItemStream(Constants.Live),
                    navigate: (entity) async => _navigationService.navigateTo(
                      '/profile/user_items/user_item_detail',
                      arguments: entity,
                    ),
                  ),
                  BuildList(
                    stream: _profileBloc.getItemStream(Constants.Sold),
                    navigate: (entity) async => _navigationService.navigateTo(
                      '/profile/user_items/user_item_detail',
                      arguments: entity,
                    ),
                  ),
                  BuildList(
                    stream: _profileBloc.getItemStream(Constants.Draft),
                    navigate: (entity) async => _navigationService.navigateTo(
                      '/profile/user_items/user_item_detail',
                      arguments: entity,
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
