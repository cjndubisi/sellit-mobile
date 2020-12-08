import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_starterkit_firebase/authentication/forgot_password/forgot_password_screen.dart';
import 'package:flutter_starterkit_firebase/authentication/login/login_form.dart';
import 'package:flutter_starterkit_firebase/authentication/register/register_form.dart';
import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/core/profile_service.dart';
import 'package:flutter_starterkit_firebase/listing/add_item/bloc/additem_bloc.dart';
import 'package:flutter_starterkit_firebase/listing/bloc/bloc.dart';
import 'package:flutter_starterkit_firebase/listing/bottom_nav_screen.dart';
import 'package:flutter_starterkit_firebase/listing/detail/detail_screen.dart';
import 'package:flutter_starterkit_firebase/listing/profile/bloc/profile_bloc.dart';
import 'package:flutter_starterkit_firebase/listing/profile/user_listing/detail_screen.dart';
import 'package:flutter_starterkit_firebase/listing/profile/user_listing/listing.dart';
import 'package:flutter_starterkit_firebase/splash.dart';
import 'package:flutter_starterkit_firebase/utils/utility.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';
import 'package:flutter_starterkit_firebase/utils/validators.dart';
import 'authentication/authentication_bloc/authentication_bloc.dart';
import 'authentication/onboarding/onboarding_page.dart';
import 'core/auth_service.dart';
import 'core/navigation_service.dart';
import 'listing/add_item/add_item_page.dart';

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
        RepositoryProvider<ListingService>(create: (_) => ListingService()),
        RepositoryProvider<ProfileService>(create: (context) => ProfileService(context.read<ListingService>())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) {
              return AuthenticationBloc(
                service: context.read<AuthService>(),
                validators: Validators(),
              )..add(AppStarted());
            },
          ),
          BlocProvider<ListingBloc>(create: (context) {
            return ListingBloc(
              service: context.read<ListingService>(),
              serviceProvider: context.read<ServiceUtilityProvider>(),
            );
          }),
          BlocProvider<AdditemBloc>(create: (context) {
            return AdditemBloc(
              addItemService: context.read<ListingService>(),
              utilityProvider: context.read<ServiceUtilityProvider>(),
            );
          }),
          BlocProvider<ProfileBloc>(create: (context) {
            final ProfileService _profileService = context.read<ProfileService>();
            return ProfileBloc(service: _profileService)..add(InitialEvent());
          })
        ],
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _navService = context.watch<NavigationService>();
    return MaterialApp(
      navigatorKey: _navService.key,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'SellIt',
      home: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext context, AuthenticationState state) async {
          switch (state.runtimeType) {
            case UnInitialized:
              await _navService.setRootRoute('/welcome');
              break;
            case LoginFormState:
              await _navService.setRootRoute('/login');
              break;
            case Authenticated:
              await _navService.setRootRoute('/dashboard');
              break;
          }
        },
        child: Splash(),
      ),
      routes: <String, WidgetBuilder>{
        '/welcome': (BuildContext context) => WelcomeScreen(),
        '/login': (BuildContext context) => LoginForm(),
        '/register': (BuildContext context) => RegisterForm(),
        '/forgot_password': (BuildContext context) => ForgotPasswordScreen(),
        '/dashboard': (BuildContext context) => BottomNavScreen(),
        '/dashboard/detail': (BuildContext context) => DetailScreen(),
        '/dashboard/add/item': (BuildContext context) => AddItemPage(),
        '/profile/user_items': (BuildContext context) => UserItemsListing(),
        '/profile/user_items/user_item_detail': (BuildContext context) => UserItemDetailPage(),
      },
    );
  }
}
