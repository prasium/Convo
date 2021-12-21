import 'package:convo/screens/auth.dart';
import 'package:convo/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './screens/chat.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Convo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        backgroundColor: Colors.deepPurple,
        accentColor: Colors.pinkAccent,
        accentColorBrightness: Brightness.dark,
        elevatedButtonTheme:ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            onPrimary: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.purple,
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if(userSnapshot.connectionState==ConnectionState.waiting)
            return SplashScreen();
          if(userSnapshot.hasData){
            return ChatScreen();
          }
          return AuthScreen();
        }
      ),
    );
  }
}
