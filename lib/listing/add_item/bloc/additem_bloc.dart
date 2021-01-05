import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_starterkit_firebase/core/item_service.dart';
import 'package:flutter_starterkit_firebase/listing/add_item/add_item_page.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

part 'additem_event.dart';
part 'additem_state.dart';

class AdditemBloc extends Bloc<AdditemEvent, AdditemState> {
  AdditemBloc({@required ItemService addItemService, @required ServiceUtilityProvider utilityProvider})
      : assert(addItemService != null),
        assert(utilityProvider != null),
        _addItemService = addItemService,
        _utilityProvider = utilityProvider,
        super(AdditemInitial());

  final ItemService _addItemService;
  final ServiceUtilityProvider _utilityProvider;

  DateTime get currentDate => _utilityProvider.getCurrentDate();

  @override
  Stream<AdditemState> mapEventToState(
    AdditemEvent event,
  ) async* {
    switch (event.runtimeType) {
      case ImageSelectedEvent:
        yield* mapToImageSelectedEvent(event as ImageSelectedEvent);
        break;
      case SubmitAddItemEvent:
        yield* mapToSubmitAddItemEvent(event as SubmitAddItemEvent);
        break;
      case ItemTypeChangedEvent:
        yield* _mapItemSelectedToState(event as ItemTypeChangedEvent);
    }
  }

  Stream<AdditemState> mapToImageSelectedEvent(ImageSelectedEvent event) async* {
    yield MultipleImageSelected(event.assetList);
  }

  Stream<AdditemState> mapToSubmitAddItemEvent(SubmitAddItemEvent event) async* {
    yield StartLoading();
    try {
      final priceD = event.entity.price;
      if (priceD == null || priceD <= 0) {
        throw 'Invalid Amount!';
      }

      await _addItemService.addItem(event.entity, event.images);

      yield LoadingSuccessful('Item Added!');
    } catch (e) {
      yield LoadingFailed(e.toString());
    }
  }

  Stream<AdditemState> _mapItemSelectedToState(ItemTypeChangedEvent event) async* {
    if (event.itemType == ItemType.UsedItem) {
      yield UsedItemSelected();
      return;
    }
    yield NewItemSelected();
    return;
  }
}
