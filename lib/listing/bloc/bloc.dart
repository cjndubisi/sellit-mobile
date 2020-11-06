import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  ListingBloc({@required ListingService service})
      : assert(service != null),
        _service = service,
        super(null);

  final ListingService _service;

  Stream<List<ItemEntity>> get itemStream => _service.itemStream;

  ListingState get initialState => InitialState();

  ItemEntity get itemEntity => _service.selectedItem;

  @override
  Stream<ListingState> mapEventToState(ListingEvent event) async* {
    switch (event.runtimeType) {
      case InActiveSearch:
        yield InitialState();
        break;
      case ListItemClickEvent:
        yield* mapToListItemClickedEvent(event);
        break;
    }
  }

  Stream<ListingState> mapToListItemClickedEvent(ListingEvent event) async* {
    final itemClickedEvent = event as ListItemClickEvent;
    _service.setSelectedItem = itemClickedEvent._itemEntity;
    yield NavigateToDetail();
  }
}
