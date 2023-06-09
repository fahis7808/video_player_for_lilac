import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_for_lilac/provider/authentication_provider.dart';
import 'package:video_player_for_lilac/provider/home_page_provider.dart';
import 'package:video_player_for_lilac/util/theme.dart';
import 'package:video_player_for_lilac/view/screen/home_page.dart';
import 'package:video_player_for_lilac/view/screen/login_page.dart';
import 'package:video_player_for_lilac/view/screen/register.dart';
import 'package:video_player_for_lilac/view/screen/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
      ],
      child:ValueListenableBuilder(
        valueListenable: themeNotifier,
    builder: (context, themeChanger, _){
          return MaterialApp(
            title: 'Video Player',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeData(ThemeMode.light),
            darkTheme: AppTheme.getThemeData(ThemeMode.dark),
            themeMode: themeChanger,
            initialRoute: 'welcomeScreen',
            // home: const LoginPage(),
            routes: {
              'welcomeScreen': (context) => WelcomeScreen(),
              'login': (context) => LoginPage(),
              'register': (context) => Registration(),
              // 'verify' : (context) => VerifyPage(),
              'homePage': (context) => HomePage()
            },
          );
        }
      ),
    );
  }
}
