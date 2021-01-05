part of 'additem_bloc.dart';

abstract class AdditemState extends Equatable {
  const AdditemState();

  @override
  List<Object> get props => [];
}

class AdditemInitial extends AdditemState {}

class MultipleImageSelected extends AdditemState {
  const MultipleImageSelected(this.assetList);
  final List<Asset> assetList;
}

class StartLoading extends AdditemState {}

class LoadingFailed extends AdditemState {
  const LoadingFailed(this.msg);
  final String msg;
}

class LoadingSuccessful extends AdditemState {
  const LoadingSuccessful(this.msg);
  final String msg;
}

class NewItemSelected extends AdditemState {}

class UsedItemSelected extends AdditemState {}
