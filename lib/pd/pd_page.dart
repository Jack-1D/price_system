import 'package:flutter/material.dart';
import 'package:price_system/pd/assignquotation.dart';
import 'package:price_system/pd/createquotation.dart';
import 'package:price_system/user_maintain.dart';

class PDScreen extends StatelessWidget {
  const PDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic user= ModalRoute.of(context)!.settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text("PD (${user['username']})"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/login", (route) => false);
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return Colors.white;
              }),
            ),
            child: const Text(
              "登出",
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShowAssignQuotation()));
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return Colors.white;
              }),
            ),
            child: const Text("報價總覽", style: TextStyle(fontSize: 20),),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateQuotation()));
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return Colors.white;
              }),
            ),
            child: const Text("新增報價", style: TextStyle(fontSize: 20),),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserMaintain()));
            },
          ),
        ],
      ),
    );
  }
}
