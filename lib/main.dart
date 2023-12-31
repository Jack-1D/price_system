import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:price_system/rd/rd_page.dart';
import 'package:price_system/pd/pd_page.dart';
import 'package:price_system/signin.dart';
import 'package:price_system/signup.dart';
import 'package:price_system/supplier/supplier_page.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SignUpApp());
}

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/RD': (context) => const RDScrren(),
        '/Supplier': (context) => const SupplierScrren(),
        '/PD': (context) => const PDScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
