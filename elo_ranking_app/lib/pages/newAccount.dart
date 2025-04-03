import 'dart:convert';
import 'package:postgres/postgres.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';

class NewAccount extends StatelessWidget {
  const NewAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Account'), centerTitle: true, backgroundColor: Colors.blueAccent, titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),),
      body: AccountForm(),
    );
  }
}

class AccountForm extends StatefulWidget {
  const AccountForm({super.key});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String userNameErrorMessage = '';
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  double errorMessageSize = 0.0;
  bool visiblePassword = true;
  double borderRadius = 10;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 30)),
            // First Name
            SizedBox(
              width: 170,
              child: TextField(
                controller: firstNameController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'First Name',
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  errorStyle: TextStyle(color: Colors.red),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 0, 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(borderRadius),
                    ),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(borderRadius),
                    ),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(borderRadius),
                    ),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(borderRadius),
                    ),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            // Last Name
            SizedBox(
              width: 170,
              child: TextField(
                controller: lastNameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Last Name',
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(borderRadius),
                    ),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(borderRadius),
                    ),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(borderRadius),
                    ),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(borderRadius),
                    ),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 30))
          ],
        ),
        // User Name Input
        Container(
          padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
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
        ),
        Align(
          alignment: Alignment(-0.4, 0),
          child: SizedBox(
            height: 15,
            child: Text(
              userNameErrorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: errorMessageSize,
              ),
            ),
          ),
        ),
        // Email Input
        Container(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
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
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Text(
            emailErrorMessage,
            style: TextStyle(
              color: Colors.red,
              fontSize: errorMessageSize,
            ),
          ),
        ),
        // Password Input
        Container(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
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
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Text(
            passwordErrorMessage,
            style: TextStyle(
              color: Colors.red,
              fontSize: errorMessageSize,
            ),
          ),
        ),
        // Create Account Button
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ElevatedButton(
            onPressed: () async {
              String firstName = firstNameController.text;
              String lastName = lastNameController.text;
              String userName = userNameController.text;
              String email = emailController.text;
              String password = passwordController.text;
          
              String validUserName = await userNameValidation(userName);
              String validEmail = await emailValidation(email);
              String validPassword = passwordValidation(password);
          
              if (validUserName != '') {
                setState(() {
                  clearErrorMessages();
                  userNameErrorMessage = validUserName;
                  errorMessageSize = 12.0;
                });
              } else if (validEmail != '') {
                setState(() {
                  clearErrorMessages();
                  emailErrorMessage = validEmail;
                  errorMessageSize = 12.0;
                });
              } else if (validPassword != '') {
                setState(() {
                  clearErrorMessages();
                  passwordErrorMessage = validPassword;
                  errorMessageSize = 12.0;
                });
              } else {
                clearErrorMessages();
                insertNewAccount(firstName, lastName, userName, email, password);
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
            child: const Text(
              'Create Account',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  void clearErrorMessages() {
    userNameErrorMessage = '';
    emailErrorMessage = '';
    passwordErrorMessage = '';
  }

  Future<String> userNameValidation(String userName) async {
    if (userName.isEmpty) {
      return 'Enter a User Name';
    } else if (userName.length < 8) {
      return 'User Name Too Short. Greater Than 8 Required.';
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

    final countUserName = await database.execute(
      r'SELECT 1 FROM t_user WHERE user_name=$1',
      parameters: [userName],
    );

    await database.close();

    return countUserName.affectedRows > 0 ? 'User Name Already Taken' : '';
  }

  Future<String> emailValidation(String email) async {
    if (email.isEmpty) {
      return 'Enter an Email';
    } else if (!EmailValidator.validate(email)) {
      return 'Invalid Email';
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

    return countEmail.affectedRows > 0 ? 'Email Is Already Registered' : '';
  }

  String passwordValidation(String password) {
    final passwordRegEx = RegExp(r'^[a-zA-Z0-9!?.+-@_*(),<>]+');

    if (password.isEmpty) {
      return 'Enter a Password';
    } else if (password.length < 8 || !passwordRegEx.hasMatch(password)) {
      return 'Enter a Valid Password. Accepted special characters: ?.+-@_*(),<>';
    }

    return '';
  }

  String saltAndHashPassword(String password, String userName) {
    String saltedPassword = password + userName;
    var passwordBytes = utf8.encode(saltedPassword);
    var hashedPassword = sha256.convert(passwordBytes);
    return hashedPassword.toString();
  }

  Future<void> insertNewAccount(String firstName, String lastName, String userName, String email, String password) async {
    // DateTime currentDateTime = DateTime.now();

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

    password = saltAndHashPassword(password, userName);

    await database.execute(
      r'INSERT INTO t_user (user_name, first_name, last_name, email_address, password) VALUES ($1, $2, $3, $4, $5)', 
      parameters: [userName, firstName, lastName, email, password]
    );

    await database.close();

    return;
  }
}