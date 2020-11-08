part of 'bloc.dart';

abstract class ListingState {}

class InitialState extends ListingState {}

class NavigateToDetail extends ListingState {
  NavigateToDetail(this.itemEntity);
  final ItemEntity itemEntity;
}
