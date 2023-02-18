import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/screens/home_screen.dart';
import 'package:instagram/widgets/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1), (() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 220,
                ),
                const Center(
                  child: Image(
                    image: AssetImage(
                      'assets/logo.png',
                    ),
                    height: 200,
                    width: 200,
                  ),
                ),
                const SizedBox(
                  height: 250,
                ),
                const Center(
                  child: Text(
                    'from',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.meta,
                        color: Colors.pink,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Meta',
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
