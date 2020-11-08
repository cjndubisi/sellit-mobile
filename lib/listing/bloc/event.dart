part of 'bloc.dart';

@immutable
abstract class ListingEvent {}

class InActiveSearch extends ListingEvent {}

class ListItemClickEvent extends ListingEvent {
  ListItemClickEvent(this._itemEntity);
  final ItemEntity _itemEntity;
}
