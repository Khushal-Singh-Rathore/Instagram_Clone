import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/home_screen.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/splash_screen.dart';
import 'package:instagram/widgets/color.dart';
import 'package:provider/provider.dart';

void main() async {
  // using this so that our flutter widgets get bind before firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  // getting firebase initialize
  await Firebase.initializeApp();
  runApp(Instagram());
}

class Instagram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: background),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const SplashScreen();
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(child: Text(snapshot.error.toString())),
                  );
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              return const LoginScreen();
            },
          )),
    );
  }
}
