import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_starterkit_firebase/listing/bloc/bloc.dart';
import 'package:flutter_starterkit_firebase/listing/widgets/widget.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

class LisitingPage extends StatefulWidget {
  @override
  _LisitingPage createState() => _LisitingPage();
}

class _LisitingPage extends State<LisitingPage> {
  final TextEditingController _filter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ListingBloc _listingBloc = context.bloc<ListingBloc>();
    return BlocBuilder<ListingBloc, ListingState>(
      builder: (BuildContext context, ListingState state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: StreamBuilder<List<ItemEntity>>(
            stream: _listingBloc.getItemStream(),
            builder: (BuildContext context, AsyncSnapshot<List<ItemEntity>> snapshot) {
              if (snapshot.hasData && snapshot.data != null && snapshot.data.isNotEmpty) {
                return StaggeredGridView.countBuilder(
                  crossAxisCount: snapshot.data.length ~/ 2,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) => ListItemWidget(snapshot.data[index]),
                  staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 2 : 1),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                );
              } else {
                if (state is SearchingState) {
                  return Center(
                    child: Text('Not found'),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, ListingState state) {
    final ListingBloc _listingBloc = context.bloc<ListingBloc>();
    if (state is SearchingState) {
      return AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
          ),
          onPressed: () {
            _listingBloc.add(InActiveSearch());
          },
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _filter,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter search term...',
                ),
                onChanged: (String value) => _listingBloc.add(SearchEvent(value)),
              ),
            ),
            Icon(
              Icons.filter_list,
              color: ColorPalette.black,
            )
          ],
        ),
      );
    }

    return AppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async => _listingBloc.add(SearchEvent()),
        )
      ],
    );
  }
}
