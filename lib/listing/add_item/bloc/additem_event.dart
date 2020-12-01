part of 'additem_bloc.dart';

abstract class AdditemEvent extends Equatable {
  const AdditemEvent();

  @override
  List<Object> get props => [];
}

class ItemTypeChangedEvent extends AdditemEvent {
  const ItemTypeChangedEvent(this.itemType);
  final ItemType itemType;
}

class ImageSelectedEvent extends AdditemEvent {
  const ImageSelectedEvent(this.assetList);
  final List<Asset> assetList;
}

class SubmitAddItemEvent extends AdditemEvent {
  const SubmitAddItemEvent([this.images, this.entity]);
  final ItemEntity entity;
  final List<Asset> images;
}
