import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price_system/db_service.dart';

class ShowPaper extends StatelessWidget {
  final ListResult listresult;
  final List<Map<String, dynamic>> paperdetail;
  const ShowPaper(
      {Key? key, required this.listresult, required this.paperdetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("圖紙總覽"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                final storageRef =
                    FirebaseStorage.instance.ref().child("papers");
                final listResult = await storageRef.listAll();
                List<Map<String, dynamic>> paperdetail = await FireDB()
                    .getPaperDetail(papernamelist: listResult.items);
              },
            ),
          ],
        ),
        body: Center(
          child: DataTableExample(
              listresult: listresult, paperdetail: paperdetail),
        ));
  }
}

class DataTableExample extends StatefulWidget {
  final ListResult listresult;
  final List<Map<String, dynamic>> paperdetail;
  const DataTableExample(
      {super.key, required this.listresult, required this.paperdetail});

  @override
  State<DataTableExample> createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
  static const int numItems = 20;
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text('圖紙名稱'),
          ),
          DataColumn(
            label: Text('Version'),
          ),
          DataColumn(
            label: Text('上傳者'),
          ),
          DataColumn(
            label: Text('上傳時間'),
          ),
        ],
        rows: List<DataRow>.generate(
          widget.paperdetail.length,
          (int index) => DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              // All rows will have the same selected color.
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              // Even rows will have a grey color.
              if (index.isEven) {
                return Colors.grey.withOpacity(0.3);
              }
              return null; // Use default value for other states and odd rows.
            }),
            cells: <DataCell>[
              DataCell(Text(widget.listresult.items[index].fullPath.substring(7))),
              DataCell(Text(widget.paperdetail[index]['version'])),
              DataCell(Text(widget.paperdetail[index]['uploader']['username'])),
              DataCell(Text(DateFormat('MM-dd  a hh:mm:ss  yyyy').format(DateTime.fromMicrosecondsSinceEpoch(widget.paperdetail[index]['uploadtime'].microsecondsSinceEpoch)))),
            ],
            selected: selected[index],
            onSelectChanged: (bool? value) {
              setState(() {
                selected[index] = value!;
              });
            },
          ),
        ),
      ),
    );
  }
}
