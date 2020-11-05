part of 'bloc.dart';

abstract class ListingState {}

class InitialState extends ListingState {}

class NavigateToDetail extends ListingState {
  NavigateToDetail(this.itemEntity);
  final ItemEntity itemEntity;
}

class StartLoading extends ListingState {}

class LoadingFailed extends ListingState {
  LoadingFailed(this.msg);
  final String msg;
}

class ContactSellerState extends ListingState {}
