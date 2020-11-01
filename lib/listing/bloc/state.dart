part of 'bloc.dart';

abstract class ListingState extends Equatable {
  const ListingState();

  @override
  List<Object> get props => <Object>[];
}

class InitialState extends ListingState {}

class NavigateToDetail extends ListingState {}
