import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'character.dart';
import 'emailVerify.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _nameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _gmailTextController = TextEditingController();
  final _companyTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  final _authData = {
    'username': '',
    'password': '',
    'gmail': '',
    'character': '',
    'name': '',
    'company': '',
  };

  double _formProgress = 0;
  String _selectedCharacter = "RD";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _nameTextController,
              decoration: const InputDecoration(hintText: '姓名'),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return '請輸入姓名';
                }
                return null;
              },
              onSaved: (value) {
                _authData['name'] = value!;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _companyTextController,
              decoration: const InputDecoration(hintText: '公司名稱'),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return '請輸入公司';
                }
                return null;
              },
              onSaved: (value) {
                _authData['company'] = value!;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return '請輸入使用者名稱';
                }
                return null;
              },
              onSaved: (value) {
                _authData['username'] = value!;
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
              validator: (value) {
                if (value!.isEmpty) {
                  return '請輸入密碼';
                }
                return null;
              },
              onSaved: (value) {
                _authData['password'] = value!;
              },
            ),
          ),
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
              onSaved: (value) {
                _authData['gmail'] = value!;
              },
            ),
          ),
          CharacterSelection(_selectedCharacter, (value) {
            setState(() {
              _selectedCharacter = value.toString();
            });
          }),
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
                onPressed: _formProgress == 1
                    ? (() async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();
                        setState(() {
                          _isLoading = true;
                        });
                        await signup(
                            gmail: _gmailTextController.text,
                            username: _usernameTextController.text,
                            password: _passwordTextController.text,
                            name: _nameTextController.text,
                            company: _companyTextController.text,
                            character: _selectedCharacter);
                        if (_auth.currentUser != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      const EmailVerificationScreen()));
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      })
                    : null,
                child: const Text('Sign up'),
              ),
              TextButton(
                style: ButtonStyle(foregroundColor:
                    MaterialStateProperty.resolveWith((states) {
                  return Colors.blue;
                })),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back to sign in'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _usernameTextController,
      _passwordTextController,
      _gmailTextController,
      _nameTextController,
      _companyTextController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  Future<User?> signup(
      {required String username,
      required String company,
      required String character,
      required String name,
      required String gmail,
      required String password}) async {
    try {
      dynamic authResult;
      authResult = await _auth.createUserWithEmailAndPassword(
          email: gmail, password: password);
      FirebaseFirestore.instance
          .collection('user')
          .doc(authResult.user.uid)
          .set({
        'gmail': gmail,
        'username': username,
        'name': name,
        'company': company,
        'character': character
      });
      return authResult.user;
    } on FirebaseAuthException catch (err) {
      var errMsg = '系統出現問題，請重新啟動。';
      if (err.code == 'invalid-email') {
        errMsg = '無效的電子信箱！';
      } else if (err.code == 'user-disabled') {
        errMsg = '此帳號已被管理員禁用！';
      } else if (err.code == 'user-not-found') {
        errMsg = '帳號不存在，請先建立帳號。';
      } else if (err.code == 'wrong-password') {
        errMsg = '密碼錯誤！';
      } else if (err.code == 'email-already-in-use') {
        errMsg = '此帳號已被使用。';
      } else if (err.code == 'operation-not-allowed') {
        errMsg = '不允許操作！';
      } else if (err.code == 'weak-password') {
        errMsg = '密碼強度不足。';
      } else if (err.code == 'too-many-requests') {
        errMsg = '請求次數過多，請稍後再試。';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        elevation: 0,
        content: Text(errMsg),
      ));
    }
  }
}
