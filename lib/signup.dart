import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_system/db_service.dart';

import 'character.dart';

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

  double _formProgress = 0;
  String _selectedCharacter = "RD";

  @override
  Widget build(BuildContext context) {
    return Form(
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _companyTextController,
              decoration: const InputDecoration(hintText: '公司名稱'),
              keyboardType: TextInputType.name,
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
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _gmailTextController,
              decoration: const InputDecoration(hintText: 'Gmail'),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@.!#\$%&'*+-/=?^_`{|}~]"))
              ],
            ),
          ),
          CharacterSelection(_selectedCharacter, (value) {
            setState(() {
              _selectedCharacter = value.toString();
            });
          }),
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
                ? () async {
                    final errmsg = await FireDB().addUser(
                        gmail: _gmailTextController.text,
                        username: _usernameTextController.text,
                        password: _passwordTextController.text,
                        name: _nameTextController.text,
                        company: _companyTextController.text,
                        character: _selectedCharacter
                        );
                    print(errmsg);
                    Navigator.of(context).pushNamed('/welcome');
                  }
                : null,
            child: const Text('Sign up'),
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
}
