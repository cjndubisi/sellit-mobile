import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_starterkit_firebase/listing/profile/user_listing/listing_widget.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';

class BuildList extends StatelessWidget {
  const BuildList({
    @required this.navigate,
    @required this.stream,
   
  })  : assert(stream != null),
        assert(navigate != null),
        super();
  
  final Stream<List<ItemEntity>> stream;
  final Future Function(ItemEntity entity) navigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot<List<ItemEntity>> snapshot) {
          if (snapshot.hasData && snapshot.data != null && snapshot.data.isNotEmpty)
            return StaggeredGridView.countBuilder(
              
              primary: false,
              crossAxisCount: 4,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) => UserListItemWidget(
                snapshot.data[index],
                (ItemEntity entity) async => navigate(entity),
              ),
              staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            );
          else
            return const Center(
              child: CircularProgressIndicator(),
            );
        },
        stream: stream,
      ),
    );
  }
}
