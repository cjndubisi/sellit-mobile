import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/utils/repository.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 180,
            ),
            Expanded(
              child: IntroductionScreen(
                globalBackgroundColor: Colors.transparent,
                showNextButton: true,
                showSkipButton: true,
                skip: const Text('Skip'),
                next: const Text('Next'),
                done: const Text('Get Started'),
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

  final PageDecoration myPage = const PageDecoration(bodyTextStyle: TextStyle(fontSize: 14));

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset('assets/images/splash1.png'),
          title: 'Sign up now',
          body: 'Do you have any item to sell / buy? Get started by creating an account',
          decoration: myPage),
      PageViewModel(
          image: Image.asset('assets/images/splash2.png'),
          title: 'Competitive',
          body: 'Prices are competitive and attractive. You have a wide range of options to choose from',
          decoration: myPage),
      PageViewModel(
          image: Image.asset('assets/images/splash3.png'),
          title: 'Speedy delivery',
          body: 'Seller accepts your bid and item gets delivered to you seamlessly',
          decoration: myPage),
    ];
  }

  void gotoLoginPage() {
    Repository.getInstance().onBoardingCompleted();
  }
}
