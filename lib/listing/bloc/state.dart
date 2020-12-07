part of 'bloc.dart';

abstract class ListingState {}

class InitialState extends ListingState {}

class NavigateToDetail extends ListingState {
  NavigateToDetail(this.itemEntity);
  final ItemEntity itemEntity;
}

class IsLoading extends ListingState {}

class LogOut extends ListingState {}

class LoadingFailed extends ListingState {
  LoadingFailed(this.msg);
  final String msg;
}

class ContactSellerState extends ListingState {}

class SearchInitial extends ListingState {}

class SearchingState extends Equatable implements ListingState {
  const SearchingState(this.term);
  final String term;

  @override
  List<Object> get props => [term];
}
