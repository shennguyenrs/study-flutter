import 'dart:convert';
import 'dart:math';

import 'package:authentication_demo/src/constants/index.dart';
import 'package:authentication_demo/src/utils/random_string.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _random = Random.secure();
  bool isChecked = false;
  bool isCheckBoxValidated = true;
  bool isShowPass = false;
  bool isShowConfirmPass = false;

  final FocusNode _focusUsername = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPass = FocusNode();
  final FocusNode _focusConfirmPass = FocusNode();
  final FocusNode _focusCheckBox = FocusNode();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  _submitForm() {
    if (!isChecked) {
      setState(() {
        isCheckBoxValidated = false;
      });
    }

    if (_formKey.currentState!.validate()) {
      final salt = generateRandomString(_random.nextInt(10));
      final encoded = utf8.encode(_passController.text + salt);
      final hashingPass = sha256.convert(encoded);

      final newUser = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': hashingPass,
        'salt': salt,
      };

      print(newUser.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Form submitted"),
        ),
      );

      _formKey.currentState?.save();
      _formKey.currentState?.reset();

      _nextFocus(_focusUsername);
      setState(() {
        isChecked = false;
      });
    }
  }

  _nextFocus(FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  // Validate username
  String? _validateUsername(String? value) {
    if (value != null) {
      if (value.trim().isEmpty) {
        return "Field is required";
      }

      RegExp pattern = RegExp(Constants.usernameRegEx);

      if (!pattern.hasMatch(value)) {
        return "Username only contains a-z, 0-9, underscore and minimun length is 5 characters";
      }
    }

    return null;
  }

  // Validate email
  String? _validateEmail(String? value) {
    if (value != null) {
      if (value.trim().isEmpty) {
        return "Field is required";
      }

      RegExp pattern = RegExp(Constants.emailRegEx);

      if (!pattern.hasMatch(value)) {
        return "Invalid email";
      }
    }

    return null;
  }

  // Validate Password
  String? _validatePass(String? value) {
    if (value != null) {
      if (value.trim().isEmpty) {
        return "Field is required";
      }

      if (value.contains(" ")) {
        return "No space in password";
      }

      if (value.length <= 6) {
        return "Password length must at least 6 characters";
      }
    }

    return null;
  }

  // Validate confirm password
  String? _validateConfirmPass(String? value) {
    if (value != null) {
      if (value.trim().isEmpty) {
        return "Field is required";
      }

      if (value != _passController.text) {
        return "Password is not match";
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  key: const Key("nameField"),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: _usernameController,
                  focusNode: _focusUsername,
                  validator: _validateUsername,
                  onFieldSubmitted: (String value) {
                    _nextFocus(_focusEmail);
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter your username",
                    labelText: "Username*",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  key: const Key("emailField"),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  focusNode: _focusEmail,
                  validator: _validateEmail,
                  onFieldSubmitted: (String value) {
                    _nextFocus(_focusPass);
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter your email",
                    labelText: "Email*",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  key: const Key("passField"),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: _passController,
                  focusNode: _focusPass,
                  validator: _validatePass,
                  onFieldSubmitted: (String value) {
                    _nextFocus(_focusConfirmPass);
                  },
                  obscureText: !isShowPass,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    labelText: "Password*",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isShowPass = !isShowPass;
                        });
                      },
                      icon: !isShowPass
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  key: const Key("confirmPassField"),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: _confirmPassController,
                  focusNode: _focusConfirmPass,
                  validator: _validateConfirmPass,
                  onFieldSubmitted: (String value) {
                    _nextFocus(_focusCheckBox);
                  },
                  obscureText: !isShowConfirmPass,
                  decoration: InputDecoration(
                    hintText: "Enter your confirm password",
                    labelText: "Confirm password*",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isShowConfirmPass = !isShowConfirmPass;
                        });
                      },
                      icon: !isShowConfirmPass
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      key: const Key("checkboxField"),
                      focusNode: _focusCheckBox,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                          isCheckBoxValidated = true;
                        });
                      },
                      value: isChecked,
                    ),
                    Flexible(
                      child: Text(
                        "I'm agree with the Service terms and Privacy policy*",
                        style: TextStyle(
                          color: isCheckBoxValidated
                              ? theme.colorScheme.onBackground
                              : theme.colorScheme.error,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    !isCheckBoxValidated ? "Field is required" : "",
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
