import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:price_system/rd/addpaper.dart';
import 'package:price_system/rd/showpaper.dart';
import 'package:price_system/user_maintain.dart';

class RDScrren extends StatelessWidget {
  const RDScrren({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic user= ModalRoute.of(context)!.settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text("RD (${user['username']})"),
        actions: [
          TextButton(
            child: Text("圖紙總覽", style: TextStyle(fontSize: 20),),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShowPaper()));
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return Colors.white;
              }),
            ),
          ),
          TextButton(
            child: Text("新增圖紙", style: TextStyle(fontSize: 20),),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddPaper()));
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return Colors.white;
              }),
            ),
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
