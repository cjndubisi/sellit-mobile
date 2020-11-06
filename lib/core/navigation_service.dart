import 'package:flutter/cupertino.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get key => _navigatorKey;

  void goBack() => _navigatorKey.currentState.pop();

  Future<dynamic> navigateTo(String routeName, {Object arguments}) {
    return _navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> setRootRoute(String routeName, {Object arguments}) {
    return _navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, (_) => false, arguments: arguments);
  }
}
