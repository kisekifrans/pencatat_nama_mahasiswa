import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'src/db_helper.dart';
import 'src/siswa.dart';

void main() {
  runApp(const MaterialApp(
    title: "CRUD di SQLite kata Pak Edy",
    home: DBTestPage(
      title: '',
    ),
  ));
}

class DBTestPage extends StatefulWidget {
  final String title;
  const DBTestPage({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DBTestPageState();
  }
}

class _DBTestPageState extends State<DBTestPage> {
  late Future<List<Siswa>> siswa;
  TextEditingController controller = TextEditingController();
  late String nama;
  late int nim;
  late int curUserId;
  final formKey = GlobalKey<FormState>();
  var dbHelper;
  late bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      siswa = dbHelper.getSiswa();
    });
  }

  clearName() {
    controller.text = "";
  }

  validationInput() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isUpdating) {
        Siswa e = Siswa(curUserId, nama, nim);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Siswa e = Siswa(null, nama, nim);
        dbHelper.save(e);
      }
      clearName();
      refreshList();
    }
  }

  form() {
    return Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (val) => val!.isEmpty ? 'Masukkan Nama' : null,
                onSaved: (val) => nama = val!,
              ),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Nim kamu baby'),
                validator: (val) => val!.isEmpty ? 'Masukkan Nim mazseh' : null,
                onSaved: (val) => nim = val! as int,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: validationInput,
                    child: Text(isUpdating ? 'UPDATE' : 'TAMBAH'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isUpdating = false;
                      });
                      clearName();
                    },
                    child: const Text('Batal'),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  SingleChildScrollView dataTable(List<Siswa> siswa) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          const DataColumn(
            label: Text('NAMA'),
          ),
          const DataColumn(
            label: Text('NIM'),
          ),
          const DataColumn(
            label: Text('DELETED'),
          )
        ],
        rows: siswa
            .map(
              (siswa) => DataRow(cells: [
                DataCell(
                  Text(siswa.nama),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = siswa.id;
                    });
                    controller.text = siswa.nama;
                  },
                ),
                DataCell(
                  Text(siswa.nim),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = siswa.id;
                    });
                    controller.text = siswa.nim;
                  },
                ),
                DataCell(IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    dbHelper.delete(siswa.id);
                    refreshList();
                  },
                )),
              ]),
            )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: siswa,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data as List<Siswa>);
          }
          if (null == snapshot.data ||
              (snapshot.data as List<Siswa>).length == 0) {
            return const Text("");
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TABEL MAHASISWA"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          form(),
          list(),
        ],
      ),
    );
  }
}
