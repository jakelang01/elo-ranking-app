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
  String firstNameErrorMessage = '';
  String lastNameErrorMessage = '';
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
          spacing: 10,
          children: [
            SizedBox(width: 20),
            FirstNameTextField(firstNameController: firstNameController, borderRadius: borderRadius),
            LastNameTextField(lastNameController: lastNameController, borderRadius: borderRadius),
            Expanded(child: Container()),
          ],
        ),
        UserNameInput(userNameController: userNameController, borderRadius: borderRadius),
        UserNameErrorMessage(userNameErrorMessage: userNameErrorMessage, errorMessageSize: errorMessageSize),
        EmailInput(emailController: emailController, borderRadius: borderRadius),
        EmailErrorMessage(emailErrorMessage: emailErrorMessage, errorMessageSize: errorMessageSize),
        PasswordInput(passwordController: passwordController, visiblePassword: visiblePassword, borderRadius: borderRadius),
        PasswordErrorMessage(passwordErrorMessage: passwordErrorMessage, errorMessageSize: errorMessageSize),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CreateAccountButton(context),
        ),
      ],
    );
  }

  ElevatedButton CreateAccountButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String firstName = firstNameController.text;
        String lastName = lastNameController.text;
        String userName = userNameController.text;
        String email = emailController.text;
        String password = passwordController.text;
    
        String validFirstName = firstNameValidation(firstName);
        String validLastName = lastNameValidation(lastName);
        String validUserName = await userNameValidation(userName);
        String validEmail = await emailValidation(email);
        String validPassword = passwordValidation(password);
    
        if (validFirstName != '') {
          setState(() {
            clearErrorMessages();
            firstNameErrorMessage = validFirstName;
            errorMessageSize = 12.0;
          });
        } else if (validLastName != '') {
          setState(() {
            clearErrorMessages();
            lastNameErrorMessage = validLastName;
            errorMessageSize = 12.0;
          });
        } else if (validUserName != '') {
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
            '/login',
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
    );
  }

  void clearErrorMessages() {
    userNameErrorMessage = '';
    emailErrorMessage = '';
    passwordErrorMessage = '';
  }

  String firstNameValidation(String firstName) {
    final firstNameRegEx = RegExp(r"^[a-zA-Z0-9-,']");

    if (firstName.isEmpty) {
      return 'Enter a First Name';
    } else if (!firstNameRegEx.hasMatch(firstName)) {
      return 'Enter a Valid First Name. Accepted special characters: -,\'';
    } else if (EmailValidator.validate(firstName)) {
      return 'First Name Cannot Be An Email';
    }

    return '';
  }

  String lastNameValidation(String lastName) {
    final lastNameRegEx = RegExp(r"^[a-zA-Z0-9-,']");

    if (lastName.isEmpty) {
      return 'Enter a Last Name';
    } else if (!lastNameRegEx.hasMatch(lastName)) {
      return 'Enter a Valid Last Name. Accepted special characters: -,\'';
    } else if (EmailValidator.validate(lastName)) {
      return 'Last Name Cannot Be An Email';
    }

    return '';
  }

  Future<String> userNameValidation(String userName) async {
    if (userName.isEmpty) {
      return 'Enter a User Name';
    } else if (userName.length < 8) {
      return 'User Name Too Short. Greater Than 8 Required.';
    } else if (EmailValidator.validate(userName)) {
      return 'User Name Cannot Be An Email';
    }

    final database = await Connection.open(
      Endpoint(
        host: '10.0.2.2',
        database: 'elo-ranking',
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
        database: 'elo-ranking',
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
    } else if (EmailValidator.validate(password)) {
      return 'Password Cannot Be An Email';
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
    final database = await Connection.open(
      Endpoint(
        host: '10.0.2.2',
        database: 'elo-ranking',
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

class PasswordErrorMessage extends StatelessWidget {
  const PasswordErrorMessage({
    super.key,
    required this.passwordErrorMessage,
    required this.errorMessageSize,
  });

  final String passwordErrorMessage;
  final double errorMessageSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Text(
        passwordErrorMessage,
        style: TextStyle(
          color: Colors.red,
          fontSize: errorMessageSize,
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.passwordController,
    required this.visiblePassword,
    required this.borderRadius,
  });

  final TextEditingController passwordController;
  final bool visiblePassword;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class EmailErrorMessage extends StatelessWidget {
  const EmailErrorMessage({
    super.key,
    required this.emailErrorMessage,
    required this.errorMessageSize,
  });

  final String emailErrorMessage;
  final double errorMessageSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Text(
        emailErrorMessage,
        style: TextStyle(
          color: Colors.red,
          fontSize: errorMessageSize,
        ),
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
    );
  }
}

class UserNameErrorMessage extends StatelessWidget {
  const UserNameErrorMessage({
    super.key,
    required this.userNameErrorMessage,
    required this.errorMessageSize,
  });

  final String userNameErrorMessage;
  final double errorMessageSize;

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

class LastNameTextField extends StatelessWidget {
  const LastNameTextField({
    super.key,
    required this.lastNameController,
    required this.borderRadius,
  });

  final TextEditingController lastNameController;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class FirstNameTextField extends StatelessWidget {
  const FirstNameTextField({
    super.key,
    required this.firstNameController,
    required this.borderRadius,
  });

  final TextEditingController firstNameController;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}