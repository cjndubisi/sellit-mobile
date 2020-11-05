part of 'bloc.dart';

@immutable
abstract class ListingEvent {}

class InActiveSearch extends ListingEvent {}

class ListItemClickEvent extends ListingEvent {
  ListItemClickEvent(this._itemEntity);
  final ItemEntity _itemEntity;

  @override
  List<Object> get props => <Object>[_itemEntity];
}

class ContactSellerEvent extends ListingEvent {
  ContactSellerEvent(this._contactSellerType, this.product);
  final ContactSellerType _contactSellerType;
  final ItemEntity product;

  @override
  List<Object> get props => <Object>[_contactSellerType,product];
}
