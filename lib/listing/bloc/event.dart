part of 'bloc.dart';

@immutable
abstract class ListingEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class InActiveSearch extends ListingEvent {}
