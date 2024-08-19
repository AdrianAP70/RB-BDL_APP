import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logins_screen/API/RestApi.dart';
import 'package:logins_screen/Pages/Pelatihan.dart';
import 'package:logins_screen/Pages/TugasStatles.dart';
import 'package:logins_screen/main.dart';
import 'package:logins_screen/utils/constants.dart';
import 'package:http/http.dart' as http;

class Tugas extends StatefulWidget {
  const Tugas({Key? key}) : super(key: key);

  @override
  State<Tugas> createState() => _TugasState();
}

class _TugasState extends State<Tugas> {
  final List<TextEditingController> _answerControllers = [];

  List<Map<String, dynamic>> dataDetail = [];
  late bool status = false;
  var isLoading = false;
  var responseJson;
  var user = jsonDecode(dataUserLogin);

  @override
  void initState() {
    super.initState();
    getData();
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
      var url = Uri.parse("$baseUrl/tugas/getMateri/" + DetailTugas.dataTugas);
      final response = await http.get(url, headers: headers);
      responseJson = json.decode(response.body);

      print(responseJson);
      setState(() {
        isLoading = false;
        status = responseJson['status'];
        print(status);
        if (status == true) {
          dataDetail = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);
          _initializeControllers();
          print(dataDetail);
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

  void uploadJawaban(data, BuildContext context) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    print(jsonEncode(data));
    try {
      var url = Uri.parse("$baseUrl/jawaban/input");
      var response =
          await http.post(url, headers: headers, body: jsonEncode(data));
      responseJson = json.decode(response.body);
      status = responseJson['status'];
      // code = responseJson['code'];
      print(responseJson);
      if (status == true) {
        Future.delayed(Duration(seconds: 1)).then((value) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: "Berhasil Upload Jawaban",
                  btnOkOnPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PelatihanHome()));
                    // Navigator.pushNamed(context, DetailMateri.routeName);
                  },
                  btnOkIcon: Icons.check,
                  btnOkColor: kPrimaryColor)
              .show();
        });
      } else {
        Future.delayed(Duration(seconds: 1)).then((value) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: responseJson['msg'],
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  btnOkColor: kColorYellow)
              .show();
          // utilsApps.dengerSnack(context, responseJson['message']);
        });
      }
      // print(dataUser);
    } catch (e) {
      print(e);
      Future.delayed(Duration(seconds: 1)).then((value) {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'Peringatan',
                desc: "Terjadi kesalahan pada server",
                btnOkOnPress: () {},
                btnOkIcon: Icons.cancel,
                btnOkColor: kColorRedSlow)
            .show();
      });
    }
  }

  void _initializeControllers() {
    _answerControllers.clear();
    for (int i = 0; i < dataDetail.length; i++) {
      _answerControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitAnswers() {
    String combinedAnswers =
        _answerControllers.map((controller) => controller.text).join(" | ");
    print(combinedAnswers);
    uploadJawaban({
      "userName": user["userName"],
      "namaPelatihan": DetailTugas.dataTugas,
      "jawabanUser": combinedAnswers,
      "status": "Dalam Proses"
    }, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tugas ' + DetailTugas.dataTugas,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(left: 30),
          width: double.infinity,
          height: 50,
          child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: _submitAnswers,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.input,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Selesai',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )),
        ),
      ),
      body: Container(
          child: Expanded(
              child: SingleChildScrollView(
        child: ListView(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            ListView.separated(
              // ignore: unnecessary_null_comparison
              itemCount: dataDetail == null ? 0 : dataDetail.length,
              shrinkWrap: true,
              primary: false,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 5,
                );
              },
              itemBuilder: (context, index) {
                return _isi(
                  dataDetail[index]['soal'],
                  dataDetail[index],
                  _answerControllers[index],
                );
              },
            ),
            SizedBox(height: 15.0)
          ],
        ),
      ))),
    );
  }

  _isi(String title, Map<String, dynamic> data,
      TextEditingController controller) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.blue[100],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
