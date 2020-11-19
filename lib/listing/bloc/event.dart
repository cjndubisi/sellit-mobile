part of 'bloc.dart';

@immutable
abstract class ListingEvent {}

class InActiveSearch extends ListingEvent {}

class ListItemClickEvent extends ListingEvent {
  ListItemClickEvent(this._itemEntity);
  final ItemEntity _itemEntity;
}

class ContactSellerEvent extends ListingEvent {
  ContactSellerEvent(this._contactSellerType, this.product);
  final ContactSellerType _contactSellerType;
  final ItemEntity product;
}

class SearchEvent extends Equatable implements ListingEvent {
  const SearchEvent([this._term = '']);
  final String _term;
  @override
  List<Object> get props => [_term];
}
