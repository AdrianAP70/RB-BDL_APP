import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logins_screen/API/RestApi.dart';
import 'package:logins_screen/Pages/Pelatihan.dart';
import 'package:logins_screen/main.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:logins_screen/Pages/Youtobe.dart';

class RiwayatPelatihan extends StatefulWidget {
  const RiwayatPelatihan({Key? key}) : super(key: key);

  @override
  State<RiwayatPelatihan> createState() => _RiwayatPelatihanState();
}

class _RiwayatPelatihanState extends State<RiwayatPelatihan> {
  List<Map<String, dynamic>> dataSertifikat = [];
  late bool status = false;
  var isLoading = false;
  var responseJson;
  var user = jsonDecode(dataUserLogin);

  @override
  void initState() {
    super.initState();
    getId();
  }

  var Downloadfile =
      'https://media.neliti.com/media/publications/249244-none-837c3dfb.pdf';
  Future<void> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      print("Storage permission granted");
      // Lakukan sesuatu jika izin diberikan
    } else if (status.isDenied) {
      print("Storage permission denied");
      // Lakukan sesuatu jika izin ditolak
    } else if (status.isPermanentlyDenied) {
      print(
          "Storage permission permanently denied. Please enable it from settings.");
      // Pandu pengguna untuk membuka pengaturan dan memberikan izin
      openAppSettings();
    }
  }

  void downloadData(fileDownload) async {
    requestStoragePermission();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      // PermissionStatus status = await Permission.storage.status;
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        String getCurrentDateTime() {
          final DateTime now = DateTime.now();
          final DateFormat formatter = DateFormat('yyyy-MM-dd HH-mm-ss');
          return formatter.format(now);
        }

        String savename = "SERTIFIKAT PELATIHAN";
        String savePath =
            dir.path + "/$savename " + getCurrentDateTime() + ".pdf";
        try {
          await Dio().download(fileDownload, savePath,
              onReceiveProgress: (received, total) {});
          print("File pdf sudah didownload");
          Fluttertoast.showToast(
            msg: "File Sudah Didownload, Lihat Folder Download Anda",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } on DioError catch (e) {
          print(e.message);
        }
      }
    } else {
      print("No permission to read and write.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PelatihanHome()));
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Text(
                'Sertifikat Pelatihan',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ListView(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                ListView.separated(
                  // ignore: unnecessary_null_comparison
                  itemCount: dataSertifikat == null ? 0 : dataSertifikat.length,
                  shrinkWrap: true,
                  primary: false,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 5,
                    );
                  },
                  itemBuilder: (context, index) {
                    return _sertifikasiCard(
                      dataSertifikat[index]['namaPelatihan'],
                      dataSertifikat[index]['status'],
                      dataSertifikat[index]['file'],
                      dataSertifikat[index],
                    );
                  },
                ),
                SizedBox(height: 15.0)
              ],
            ),
          )),
    );
  }

  _sertifikasiCard(jenis, status, file, data) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, DetailProductscreens.routeName,
        //     arguments: data);
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
            ],
          ),
          margin: EdgeInsets.only(top: 10),
          child: Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: status == "Diterima" ? Colors.green : Colors.grey,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  status == "Diterima" ? Icons.check_circle : Icons.access_time,
                  color: status == "Diterima" ? Colors.green : Colors.grey,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sertifikat " + jenis,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        status,
                        style: TextStyle(
                            fontSize: 14,
                            color: status == "Diterima"
                                ? Colors.green
                                : Colors.red),
                      ),
                    ],
                  ),
                ),
                if (status == "Diterima")
                  TextButton(
                    onPressed: () {
                      var urlFile = "$baseUrl/gambar-sertifikat/$file";
                      print(urlFile);
                      downloadData(urlFile);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Youtube(url: urlFile),
                        ),
                      );
                    },
                    child: Text('Periksa'),
                  ),
              ],
            ),
          )),
    );
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
      responseJson = json.decode(response.body);

      print(responseJson);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        print(status);
        if (status == true) {
          dataSertifikat = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);
          print(dataSertifikat);
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
}