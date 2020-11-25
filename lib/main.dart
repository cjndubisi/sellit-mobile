import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_starterkit_firebase/authentication/forgot_password/forgot_password_screen.dart';
import 'package:flutter_starterkit_firebase/authentication/register/register_screen.dart';
import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/listing/widgets/screen.dart';
import 'package:flutter_starterkit_firebase/listing/bloc/bloc.dart';
import 'package:flutter_starterkit_firebase/listing/detail/detail_screen.dart';
import 'package:flutter_starterkit_firebase/utils/utility.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';
import 'authentication/authentication_bloc/authentication_bloc.dart';
import 'authentication/login/login_screen.dart';
import 'authentication/onboarding/onboarding_page.dart';
import 'core/auth_service.dart';
import 'core/navigation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DotEnv().load();
  runApp(DI());
}

class DI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthService>(create: (_) => AuthService()),
          RepositoryProvider<NavigationService>(create: (_) => NavigationService()),
          RepositoryProvider<UtilityProvider>(create: (_) => UtilityProvider()),
          RepositoryProvider(create: (_) => ServiceUtilityProvider()),
          RepositoryProvider<ListingService>(create: (_) => ListingService())
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
              create: (context) {
                return AuthenticationBloc(service: context.repository<AuthService>())..add(AppStarted());
              },
            ),
            BlocProvider<ListingBloc>(create: (context) {
              return ListingBloc(
                service: context.repository<ListingService>(),
                serviceProvider: context.repository<ServiceUtilityProvider>(),
              );
            }),
          ],
          child: MyApp(),
        ));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _navService = context.repository<NavigationService>();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'SellIt',
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
          switch (state.runtimeType) {
            case UnInitialized:
              return WelcomeScreen();
            case UnAuthenticated:
            case Authenticated:
              return ListingScreen();
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/register': (BuildContext context) => RegisterScreen(),
        '/forgot_password': (BuildContext context) => ForgotPasswordScreen(),
        '/dashboard': (BuildContext context) => ListingScreen(),
        '/dashboard/detail': (BuildContext context) => DetailScreen(),
      },
      navigatorKey: _navService.key,
    );
  }
}
