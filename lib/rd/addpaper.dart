import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPaper extends StatelessWidget {
  const AddPaper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新增圖紙"),
      ),
      body: const Center(
        child: SizedBox(
          width: 600,
          child: Card(
            child: AddPaperForm(),
          ),
        ),
      ),
    );
  }
}

class AddPaperForm extends StatefulWidget {
  const AddPaperForm({super.key});

  @override
  State<AddPaperForm> createState() => _AddPaperFormState();
}

class _AddPaperFormState extends State<AddPaperForm> {
  final _papernamecontroller = TextEditingController();
  final _paperversioncontroller = TextEditingController();
  String uploadMSG = "";
  PlatformFile? file;

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: () {
        setState(() {});
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: _papernamecontroller,
              decoration: const InputDecoration(hintText: '圖紙名稱'),
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp("[/]"))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: _paperversioncontroller,
              decoration: const InputDecoration(hintText: 'Version'),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.blue;
                  }),
                ),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      file = result.files.first;
                    });
                  }
                },
                child: Text(file == null ? 'Upload File' : file!.name)),
          ),
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
              onPressed: _papernamecontroller.value.text.isNotEmpty &&
                      _paperversioncontroller.value.text.isNotEmpty &&
                      file != null
                  ? () async {
                      if (file!.bytes == null) {
                        uploadMSG = "檔案有問題";
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          elevation: 0,
                          content: Text(uploadMSG),
                          duration: const Duration(seconds: 1),
                        ));
                      } else {
                        final uploadref = await FirebaseStorage
                            .instance
                            .ref('papers/${_papernamecontroller.text}');
                          uploadref.putData(file!.bytes!).snapshotEvents.listen((TaskSnapshot event) {
                            String? prestate = uploadMSG;
                            switch (event.state) {
                              case TaskState.paused:
                                uploadMSG = "暫停上傳";
                                break;
                              case TaskState.running:
                                uploadMSG = "正在上傳";
                                break;
                              case TaskState.success:
                                uploadMSG = "上傳成功";
                                break;
                              case TaskState.canceled:
                                uploadMSG = "取消上傳";
                                break;
                              case TaskState.error:
                                uploadMSG = "上傳失敗";
                                break;
                            }
                            if(prestate != uploadMSG){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor:
                                    Theme.of(context).primaryColor.withOpacity(0.8),
                                elevation: 0,
                                content: Text(uploadMSG),
                                duration: const Duration(seconds: 1),
                              ));
                            }
                          });
                      }
                    }
                  : null,
              child: const Text("新增")),
        ],
      ),
    );
  }
}
