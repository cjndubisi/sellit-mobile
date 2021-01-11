import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_starterkit_firebase/listing/profile/profile_screen.dart';
import 'package:flutter_starterkit_firebase/listing/widgets/listing.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  var allDestinations = <Destination>[Destination('Home', Icons.home), Destination('profile', Icons.settings)];

  var screens = [
    LisitingPage(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            label: destination.title,
          );
        }).toList(),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class Destination {
  const Destination(
    this.title,
    this.icon,
  );
  final String title;
  final IconData icon;
}
