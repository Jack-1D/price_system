import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:price_system/db_service.dart';
import 'package:price_system/rd/addpaper.dart';
import 'package:price_system/rd/showpaper.dart';
import 'package:price_system/user_maintain.dart';

class RDScrren extends StatelessWidget {
  const RDScrren({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic user = ModalRoute.of(context)!.settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text("RD (${user['username']})"),
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
            onPressed: () async {
              final storageRef = FirebaseStorage.instance.ref().child("papers");
              final listResult = await storageRef.listAll();
              List<Map<String, dynamic>> paperdetail = await FireDB()
                  .getPaperDetail(papernamelist: listResult.items);
              print("listResult: ${listResult.items}");
              print("paperdetail: $paperdetail");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowPaper(
                          listresult: listResult, paperdetail: paperdetail)));
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return Colors.white;
              }),
            ),
            child: const Text(
              "圖紙總覽",
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPaper(user: user)));
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return Colors.white;
              }),
            ),
            child: const Text(
              "新增圖紙",
              style: TextStyle(fontSize: 20),
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
