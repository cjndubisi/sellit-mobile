import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_starterkit_firebase/core/auth_service.dart';

import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  ListingBloc(
      {@required ListingService service,
      @required ServiceUtilityProvider serviceProvider,
      @required AuthService authService})
      : assert(service != null),
        assert(serviceProvider != null),
        assert(authService != null),
        _authService = authService,
        _service = service,
        _util = serviceProvider,
        super(InitialState());

  final ListingService _service;
  final ServiceUtilityProvider _util;
  final AuthService _authService;

  Stream<List<ItemEntity>> getItemStream() {
    if (state is SearchingState) {
      if ((state as SearchingState).term.isEmpty) {
        return _service.itemStream;
      }

      return _searchItem((state as SearchingState).term);
    } else {
      return _service.itemStream;
    }
  }

  Stream<List<ItemEntity>> _searchItem([String term = '']) =>
      _service.itemStream?.map((event) => event
          .where((element) =>
              element.author.name.contains(term) ||
              element.title.contains(term) ||
              element.description.contains(term))
          .toList());

  @override
  Stream<ListingState> mapEventToState(ListingEvent event) async* {
    if (event is InActiveSearch) {
      yield InitialState();
    } else if (event is ListItemClickEvent) {
      yield NavigateToDetail(event._itemEntity);
    } else if (event is ContactSellerEvent) {
      yield* _mapToContactSellerEvent(event);
    } else if (event is SearchEvent) {
      yield* _mapToSearchingEvent(event);
    } else if (event is LogOutEvent) {
      yield* _mapToLogOutEvent();
    }
  }

  Stream<ListingState> _mapToContactSellerEvent(ContactSellerEvent event) async* {
    try {
      yield IsLoading();
      _util.sendSms(event._contactSellerType, event.product);
      yield ContactSellerState();
    } catch (e) {
      yield LoadingFailed(e.toString());
    }
  }

  Stream<ListingState> _mapToLogOutEvent() async* {
    try {
      yield IsLoading();
      await _authService.signOut();
      yield LogOut();
    } catch (e) {
      yield LoadingFailed(e.toString());
    }
  }

  Stream<ListingState> _mapToSearchingEvent(SearchEvent event) async* {
    yield SearchingState(event._term);
  }
}
