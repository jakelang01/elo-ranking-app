import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:postgres/postgres.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
        child: Column(
          spacing: 15,
          children: [
            SizedBox(height: 150),
            BuildLogo(),
            BuildInputForm(),
          ],
        ),
      ),
    );
  }
}

Widget BuildLogo() => Column(
  children: [
    // App Logo
    SvgPicture.asset(
      'assets/icons/foosball.svg',
      //colorFilter: const ColorFilter.mode(Colors.brown, BlendMode.srcIn),
      semanticsLabel: 'Elo Ranker Logo',
      height: 200,
      width: 200,
    ),
    // Welcome Text
    Text(
      'Welcome to Elo Ranker',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 30,
      ),
    ),
  ],
);

class BuildInputForm extends StatefulWidget {
  const BuildInputForm({super.key});

  @override
  State<BuildInputForm> createState() => _BuildInputFormState();
}

class _BuildInputFormState extends State<BuildInputForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';
  double errorMessageSize = 0.0;
  bool visiblePassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background box
        BackgroundBox(),
        Column(
          children: [
            // Error message text
            SizedBox(
              height: 30,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: errorMessageSize),
                ),
              ),
            ),
            EmailInput(emailController: emailController),
            SizedBox(height: 10),
            PasswordInput(passwordController: passwordController, visiblePassword: visiblePassword),
            SizedBox(height: 10),
            LogInButton(context),
            SizedBox(height: 5),
            NewAccountButton(),
            ForgotPasswordButton(),
          ],
        ),
      ],
    );
  }

  SizedBox LogInButton(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        onPressed: () async {
          String email = emailController.text;
          String password = passwordController.text;
      
          if (!await emailValidation(email) ||
              !await passwordValidation(email, password)) {
            setState(() {
              errorMessage = 'Invalid Credentials';
              errorMessageSize = 18.0;
              passwordController.clear();
            });
          } else {
            updateLastLogIn(email);
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (_) => false,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          side: BorderSide(color: Colors.black, width: 2),
        ),
        child: const Text('Log In', style: TextStyle(color: Colors.black)),
      ),
    );
  }

  void toggleVisiblePassword() {
    setState(() {
      visiblePassword = !visiblePassword;
    });
  }

  Future<bool> emailValidation(String email) async {
    if (email.isEmpty) {
      return false;
    }

    final database = await Connection.open(
      Endpoint(
        host: '10.0.2.2',
        /*192.168.0.17*/
        database: 'finance',
        /*finance*/
        username: 'postgres',
        password: 'password',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    final countEmail = await database.execute(
      r'SELECT 1 FROM t_user WHERE email_address=$1',
      parameters: [email],
    );

    await database.close();

    return countEmail.affectedRows > 0;
  }

  Future<bool> passwordValidation(String email, String password) async {
    if (password.isEmpty) {
      return false;
    }

    final database = await Connection.open(
      Endpoint(
        host: '10.0.2.2',
        /*192.168.0.17*/
        database: 'finance',
        username: 'postgres',
        password: 'password',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    final dbPassword = await database.execute(
      r'SELECT password, user_name FROM t_user WHERE email_address=$1',
      parameters: [email],
    );

    await database.close();

    String userName = dbPassword[0][1].toString();

    return saltAndHashPassword(password, userName) == dbPassword[0][0] ? true : false;
  }

  String saltAndHashPassword(String password, String userName) {
    String saltedPassword = password + userName;
    var passwordBytes = utf8.encode(saltedPassword);
    var hashedPassword = sha256.convert(passwordBytes);
    return hashedPassword.toString();
  }

  Future<void> updateLastLogIn(String email) async {
    DateTime currentDateTime = DateTime.now();

    final database = await Connection.open(
      Endpoint(
        host: '10.0.2.2',
        /*192.168.0.17*/
        database: 'finance',
        username: 'postgres',
        password: 'password',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    await database.execute(r'UPDATE t_user SET last_log_in = $1 WHERE email_address = $2', parameters: [currentDateTime, email]);

    await database.close();

    return;
  }
}

class BackgroundBox extends StatelessWidget {
  const BackgroundBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 275,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey,
      ),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/forgot');
        },
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.all(2),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class NewAccountButton extends StatelessWidget {
  const NewAccountButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(width: 8),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/newAcc');
            },
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.all(2),
              tapTargetSize: MaterialTapTargetSize.padded,
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.passwordController,
    required this.visiblePassword,
  });

  final TextEditingController passwordController;
  final bool visiblePassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: passwordController,
        obscureText: !visiblePassword,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.black),
          labelStyle: TextStyle(color: Colors.black),
          errorStyle: TextStyle(color: Colors.red),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 0, 15),
          // suffix: IconButton(
          //   onPressed: toggleVisiblePassword,
          //   icon: Icon(
          //     visiblePassword ? Icons.visibility_off : Icons.visibility,
          //     size: 5,
          //   ),
          // ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(color: Colors.black),
          labelStyle: TextStyle(color: Colors.black),
          errorStyle: TextStyle(color: Colors.red),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 0, 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}