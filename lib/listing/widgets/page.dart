import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_starterkit_firebase/core/navigation_service.dart';
import 'package:flutter_starterkit_firebase/listing/bloc/bloc.dart';
import 'package:flutter_starterkit_firebase/listing/widgets/widget.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ListingBloc listingBloc = BlocProvider.of<ListingBloc>(context);
    final NavigationService navigationService = context.watch<NavigationService>();
    return BlocListener<ListingBloc, ListingState>(
      listener: (BuildContext context, ListingState state) {
        switch (state.runtimeType) {
          case InitialState:
            break;
          case NavigateToDetail:
            navigationService.navigateTo('/dashboard/detail');
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sellit',
            style: style,
          ),
        ),
        body: StreamBuilder<List<ItemEntity>>(
          stream: listingBloc.getItemStream(),
          builder: (BuildContext context, AsyncSnapshot<List<ItemEntity>> snapshot) {
            if (snapshot.hasData && snapshot.data != null && snapshot.data.isNotEmpty)
              return StaggeredGridView.countBuilder(
                crossAxisCount: snapshot.data.length ~/ 2,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) => ListItemWidget(snapshot.data[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 2 : 1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              );
            else
              return const Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
    );
  }
}
