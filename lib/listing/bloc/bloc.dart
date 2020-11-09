import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  ListingBloc({@required ListingService service, @required ServiceUtilityProvider serviceProvider})
      : assert(service != null),
        assert(serviceProvider != null),
        _service = service,
        _util = serviceProvider,
        super(InitialState());

  final ListingService _service;
  final ServiceUtilityProvider _util;
  Stream<List<ItemEntity>> get itemStream => _service.itemStream;

  @override
  Stream<ListingState> mapEventToState(ListingEvent event) async* {
    if (event is InActiveSearch) {
      yield InitialState();
    } else if (event is ListItemClickEvent) {
      yield NavigateToDetail(event._itemEntity);
    } else if (event is ContactSellerEvent) {
      yield* _mapToContactSellerEvent(event);
    }
  }

  Stream<ListingState> _mapToContactSellerEvent(ContactSellerEvent event) async* {
    try {
      yield StartLoading();
      _util.sendSms(event._contactSellerType, event.product);
      yield ContactSellerState();
    } catch (e) {
      yield LoadingFailed(e.toString());
    }
  }
}
