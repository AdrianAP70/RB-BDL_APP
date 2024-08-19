import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logins_screen/API/RestApi.dart';
import 'package:logins_screen/Pages/DashboardUser.dart';
import 'package:logins_screen/Pages/PelatihanDetailStateless.dart';
import 'package:logins_screen/Pages/RiwayayatPelatihan.dart';
import 'package:logins_screen/main.dart';
import 'package:http/http.dart' as http;
import 'package:logins_screen/utils/constants.dart';

class PelatihanHome extends StatefulWidget {
  const PelatihanHome({Key? key}) : super(key: key);

  @override
  State<PelatihanHome> createState() => _PelatihanHomeState();
}

class _PelatihanHomeState extends State<PelatihanHome> {
  List<Map<String, dynamic>> dataPelatihan = [];
  List<Map<String, dynamic>> dataSertif = [];
  late bool status = false;
  int totalElements = 0;
  var isLoading = false;
  var responseJson;
  var responseJson2;
  var user = jsonDecode(dataUserLogin);

  @override
  void initState() {
    super.initState();
    getData();
    getId();
  }

  Future<String> getData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
    };

    try {
      var url = Uri.parse("$baseUrl/kategoriKelas/get-all");
      final response = await http.get(url, headers: headers);
      responseJson = json.decode(response.body);

      print(responseJson);
      setState(() {
        isLoading = false;
        status = responseJson['status'];
        print(status);
        if (status == true) {
          dataPelatihan = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);
          print(dataPelatihan);
        } else {
          // pengembali = true;
        }
      });
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          status = false;
          isLoading = false;
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: "Tidak dapat terhububg ke server",
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  onDissmissCallback: (type) async {
                    // SystemNavigator.pop();
                  },
                  btnOkColor: kColorRedSlow)
              .show();
        });
      }
    }
    return 'success';
  }

  Future<String> getId() async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
    };

    try {
      var url = Uri.parse("$baseUrl/jawaban/getUserId/" + user["userName"]);
      final response = await http.get(url, headers: headers);
      responseJson2 = json.decode(response.body);

      print(responseJson2);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        print(status);
        if (status == true) {
          dataSertif = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);
          print(dataSertif);
          totalElements = dataSertif.length;
          // print(TO);
        } else {
          // pengembali = true;
        }
      });
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          print(".");
        });
      }
    }
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          child: Text("Pelatihan"),
        ),
        actions: <Widget>[
          Stack(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 10, top: 20),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RiwayatPelatihan()));
                        },
                        child: Icon(
                          Icons.message,
                          color: Colors.black,
                        )),
                  )),
              totalElements != 0
                  ? Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$totalElements',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardScreen()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Katalog Kelas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
                child: SingleChildScrollView(
              child: ListView(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  ListView.separated(
                    // ignore: unnecessary_null_comparison
                    itemCount: dataPelatihan == null ? 0 : dataPelatihan.length,
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                    itemBuilder: (context, index) {
                      return _sertifikasiCard(
                        "$baseUrl/gambar-barang/${dataPelatihan[index]['gambar']}",
                        dataPelatihan[index]['namaPelatihan'],
                        dataPelatihan[index]['deskripsi'],
                        dataPelatihan[index],
                      );
                    },
                  ),
                  SizedBox(height: 15.0)
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  _sertifikasiCard(imageUrl, title, description, data) {
    return TextButton(
        onPressed: () {
          print(data);
          Navigator.pushNamed(context, DetailPelatihan.routeName,
              arguments: data);
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
