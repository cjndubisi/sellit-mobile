import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/core/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _navigationService = context.repository<NavigationService>();
    return Container(
      child: Center(
        child: FlatButton(
          onPressed: () => _navigationService.navigateTo('/profile/user_items'),
          child: Text('Items'),
          color: Colors.green,
        ),
      ),
    );
  }
}
