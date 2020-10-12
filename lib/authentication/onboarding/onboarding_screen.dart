import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/utils/constants.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class WelcomeActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 180,
            ),
            Expanded(
              child: IntroductionScreen(
                globalBackgroundColor: Colors.transparent,
                showNextButton: true,
                showSkipButton: true,
                skip: Text("Skip"),
                next: Text("Next"),
                done: Text("Get Started"),
                pages: getPages(),
                onDone: () => gotoLoginPage(),
                onSkip: () => gotoLoginPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final myPage = const PageDecoration(bodyTextStyle: TextStyle(fontSize: 14));

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset("assets/images/splash1.png"),
          title: "Sign up now",
          body: "Do you have any item to sell / buy? Get started by creating an account",
          decoration: myPage),
      PageViewModel(
          image: Image.asset("assets/images/splash2.png"),
          title: "Competitive",
          body: "Prices are competitive and attractive. You have a wide range of options to choose from",
          decoration: myPage),
      PageViewModel(
          image: Image.asset("assets/images/splash3.png"),
          title: "Speedy delivery",
          body: "Seller accepts your bid and item gets delivered to you seamlessly",
          decoration: myPage),
    ];
  }

  gotoLoginPage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(Constants.FIRST_TIME, false);
    navigateTo('/register');
  }
}
