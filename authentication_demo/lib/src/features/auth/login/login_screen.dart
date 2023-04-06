import 'package:authentication_demo/src/features/auth/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:authentication_demo/src/constants/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPass = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = {
        'email': _emailController.text,
        'pass': _passController.text,
      };

      print(user.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Form submitted"),
        ),
      );

      _formKey.currentState?.save();
      _formKey.currentState?.reset();
      _nextFocus(_focusEmail);
    }
  }

  _nextFocus(FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  String? _validateEmail(String? value) {
    if (value != null) {
      if (value.trim().isEmpty) {
        return "Field is required";
      }

      RegExp regex = RegExp(Constants.emailRegEx);

      if (!regex.hasMatch(value)) {
        return "Invalid email";
      }
    }

    return null;
  }

  // Validate password
  String? _validatePass(String? value) {
    if (value != null) {
      if (value.trim().isEmpty) {
        return "Field is required";
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  key: const Key('emailField'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusEmail,
                  controller: _emailController,
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  key: const Key('passField'),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  focusNode: _focusPass,
                  controller: _passController,
                  validator: _validatePass,
                  onFieldSubmitted: (String value) {
                    _submitForm();
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Enter your password",
                    labelText: "Password*",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text(
                        "Submit",
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Register",
                      ),
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
