  import 'package:speproject1/screens/scbd_screen.dart';
  import 'package:flutter/material.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'screens/unlock_screen.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    runApp(const MyHighScore());
  }

  class MyHighScore extends StatelessWidget {
    const MyHighScore({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        initialRoute: '/unlock',
        routes: {
          '/unlock': (context) => UnlockScreen(),
          '/home': (context) => ScbdScreen(),
        },
        debugShowCheckedModeBanner: false,
      );
    }
  }
