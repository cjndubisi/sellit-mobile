part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class NavigateToUserItemDetail extends ProfileState {
  NavigateToUserItemDetail(this.itemEntity);
  final ItemEntity itemEntity;
}

class ProfileInitial extends ProfileState {}

class ListLiveState extends ProfileState {
  ListLiveState(this._filter);
  final String _filter;

  @override
  List<Object> get props => [_filter];
}

class DraftListState extends ProfileState {
  DraftListState(this._filter);
  final String _filter;

  @override
  List<Object> get props => [_filter];
}

class SoldListState extends ProfileState {
  SoldListState(this._filter);
  final String _filter;

  @override
  List<Object> get props => [_filter];
}

class ProfileErrorState extends ProfileState {
  ProfileErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadingSuccessState extends ProfileState {}
