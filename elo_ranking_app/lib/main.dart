import 'package:elo_ranking_app/pages/forgotPassword.dart';
import 'package:elo_ranking_app/pages/home.dart';
import 'package:elo_ranking_app/pages/login.dart';
import 'package:elo_ranking_app/pages/newAccount.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LogIn(),
      routes: {
        '/home': (BuildContext context) => HomePage(),
        '/forgot': (BuildContext context) => ForgotPassword(),
        '/newAcc': (BuildContext context) => NewAccount(),
        '/login': (BuildContext context) => LogIn(),
      },
    );
  }
}