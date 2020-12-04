import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/core/navigation_service.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  AuthenticationBloc _authenticationBloc;
  NavigationService _navigationService;
  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _navigationService = RepositoryProvider.of<NavigationService>(context);
  }

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
                skip: const Text(
                  'Skip',
                  key: ValueKey('skip_button'),
                ),
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

  void gotoLoginPage() async {
    _authenticationBloc.add(OnBoardingCompleted());
    await _navigationService.setRootRoute('/login');
  }
}
