import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:notetaking/pages/home_page.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MyHomePage(title: "TaskBud"))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topLeft,
              colors: [Color(0xffFEFBEA), Color(0xffFEFBEA)])),
      child: Center(
          child: Image.asset(
        'assets/images/TaskBud_logo.png',
        height: 120,
        width: 120,
      )),
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     Column(
      //       children: [
      //         Image.asset(
      //           'assets/images/TaskBud_logo.png',
      //           height: 100,
      //           width: 150,
      //         ),
      //         const Text(
      //           "TaskBud",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold,
      //             fontSize: 24,
      //           ),
      //         ),
      //       ],
      //     ),
      //     const CircularProgressIndicator(),
      //   ],
      // ),
    ));
  }
}
