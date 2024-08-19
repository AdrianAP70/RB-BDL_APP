import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logins_screen/API/RestApi.dart';
import 'package:logins_screen/Pages/Pelatihan.dart';
import 'package:logins_screen/Pages/PelatihanDetailMateri.dart';
import 'package:logins_screen/Pages/PelatihanDetailStateless.dart';
import 'package:logins_screen/Pages/TugasStatles.dart';
import 'package:logins_screen/main.dart';
import 'package:http/http.dart' as http;
import 'package:logins_screen/utils/constants.dart';

class PelatihanDetail extends StatefulWidget {
  const PelatihanDetail({Key? key}) : super(key: key);

  @override
  State<PelatihanDetail> createState() => _PelatihanDetailState();
}

class _PelatihanDetailState extends State<PelatihanDetail> {
  List<Map<String, dynamic>> dataDetail = [];
  late bool status = false;
  var isLoading = false;
  var responseJson;
  var user = jsonDecode(dataUserLogin);
  var isiTugas;

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
      var url = Uri.parse("$baseUrl/materi/getMateri/" +
          DetailPelatihan.dataPelatihan["namaPelatihan"]);
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
          print(dataDetail);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pelatihan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PelatihanHome()));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            var isi = DetailPelatihan.dataPelatihan["namaPelatihan"];
            print(isi);
            Navigator.pushNamed(context, DetailTugas.routeName, arguments: isi);
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Tugas()));
          },
          child: Container(
              width: double.infinity,
              child: Icon(
                Icons.edit_note,
                color: Colors.white,
              ))),
      body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
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
                      dataDetail[index]['judulMateri'],
                      dataDetail[index],
                    );
                  },
                ),
                SizedBox(height: 15.0)
              ],
            ),
          ))),
    );
  }

  _isi(title, data) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Training()));
          // print(data);
          Navigator.pushNamed(context, DetailMateri.routeName, arguments: data);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          minimumSize: Size(double.infinity, 50), // Adjust the height as needed
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
