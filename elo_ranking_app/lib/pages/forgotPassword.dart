import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  double borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'), 
        centerTitle: true, 
        backgroundColor: Colors.blueAccent, 
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, 
          color: Colors.black, 
          fontSize: 24
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 300,
            height: 30,
            margin: EdgeInsets.only(top: 10, right: 30),
            child: Text(
              'Enter your User Name',
            ),
          ),
          UserNameInput(userNameController: userNameController, borderRadius: borderRadius),
          Container(
            width: 300,
            height: 30,
            margin: EdgeInsets.only(top: 10, right: 30),
            child: Text(
              'Enter your email',
            ),
          ),
          EmailInput(emailController: emailController, borderRadius: borderRadius),
        ],
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({
    super.key,
    required this.emailController,
    required this.borderRadius,
  });

  final TextEditingController emailController;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(color: Colors.black),
          labelStyle: TextStyle(color: Colors.black),
          errorStyle: TextStyle(color: Colors.red),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 0, 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}

class UserNameInput extends StatelessWidget {
  const UserNameInput({
    super.key,
    required this.userNameController,
    required this.borderRadius,
  });

  final TextEditingController userNameController;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: userNameController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'User Name',
          hintStyle: TextStyle(color: Colors.black),
          labelStyle: TextStyle(color: Colors.black),
          errorStyle: TextStyle(color: Colors.red),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 0, 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
