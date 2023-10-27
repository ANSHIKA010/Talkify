import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:talkify/Pages/login_page.dart';
import 'package:talkify/pages/home_page.dart';
import 'Pages/registration_page.dart';
import './services/navigation_service.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: NavigationService.instance.navigatorKey,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(42, 117, 188, 1),
        colorScheme: const ColorScheme(background: Color.fromRGBO(28, 27, 27, 1), onBackground: Colors.white, brightness: Brightness.dark, primary: Color.fromRGBO(42, 117, 188, 1), onPrimary: Colors.white, secondary: Color.fromRGBO(42, 117, 188, 1), onSecondary: Colors.white70, error: Colors.redAccent, onError: Colors.white, surface: Colors.black26, onSurface: Colors.white60 ),
      ),
      initialRoute: "login",
      routes: {
        "login": (BuildContext _context) => LoginPage(),
        "register": (BuildContext _context) => const RegistrationPage(),
        "home": (BuildContext _context) => HomePage(),
      },
    );
  }
}
