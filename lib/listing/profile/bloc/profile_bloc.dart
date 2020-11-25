import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/core/profile_service.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({@required ProfileService service})
      : assert(service != null),
        _service = service,
        super(ProfileInitial());

  final ProfileService _service;

  Stream<List<ItemEntity>> getItemStream(String type) => _service.getUserItems(type);

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {}
}
