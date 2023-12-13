import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_system/db_service.dart';
import 'package:price_system/rd/rd_page.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignInForm(),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _gmailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Login', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _gmailTextController,
              decoration: const InputDecoration(hintText: 'Gmail'),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp("[a-zA-Z0-9@!#\$%&'*+-/=?^_`{|}~:;,<>()\".]"))
              ],
              validator: (value) {
                final bool valid = RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                    .hasMatch(value!);
                if (value.isEmpty || !valid) {
                  return '請輸入正確信箱';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _passwordTextController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : Colors.white;
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : Colors.blue;
                  }),
                ),
                onPressed: _gmailTextController.value.text.isNotEmpty &&
                        _passwordTextController.value.text.isNotEmpty
                    ? () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();
                        User? userdetail = await signin(
                            gmail: _gmailTextController.text,
                            password: _passwordTextController.text);
                        if (userdetail != null) {
                          dynamic user = await FireDB().getUser(userdetail.uid);
                          switch (user['character']) {
                            case "RD":
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/RD", (route) => false, arguments: user);
                              break;
                            case "Supplier":
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/Supplier", (route) => false, arguments: user);
                              break;
                            case "PD":
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/PD", (route) => false, arguments: user);
                              break;
                            default:
                          }
                        }
                      }
                    : null,
                child: const Text('login'),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.blue;
                  }),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("/signup");
                },
                child: const Text('No account? Press to sign up'),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _updateFormProgress() {
    setState(() {});
  }

  Future<User?> signin(
      {required String gmail, required String password}) async {
    try {
      dynamic authResult;
      authResult = await _auth.signInWithEmailAndPassword(
          email: gmail, password: password);
      return authResult.user;
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        elevation: 0,
        content: Text("Gmail or Password error (${err.code})"),
      ));
    }
    return null;
  }
}
