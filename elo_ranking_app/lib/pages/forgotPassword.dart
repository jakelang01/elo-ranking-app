import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password'), centerTitle: true, backgroundColor: Colors.blueAccent, titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),),
    );
  }
}