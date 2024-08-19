import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logins_screen/Screens/Features/USERS/Transaksi/DetailTransaksi.dart';
import '../../API/RestApi.dart';
import '../../main.dart';
import '../../utils/constants.dart';

class TransaksiScreens extends StatefulWidget {
  @override
  _TransaksiScreens createState() => _TransaksiScreens();
}

class _TransaksiScreens extends State<TransaksiScreens> {
  var isLoading = false;
  var responseJson;
  List<Map<String, dynamic>> dataTransaksi = [];
  late bool status = false;
  var user = jsonDecode(dataUserLogin);
  var pengembali = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Widget getBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 30,
            right: 30,
          ),
          child: Text(
            "Data Transaksi Anda",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 30),
          child: pengembali
              ? Text(
                  "(Tidak Ada Data Transaksi)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                )
              : Text(""),
        ),
        // tarok disini
        isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  ListView.separated(
                    // ignore: unnecessary_null_comparison
                    itemCount: dataTransaksi == null ? 0 : dataTransaksi.length,
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                    itemBuilder: (context, index) {
                      return _transaksi(
                        dataTransaksi[index]['_id'],
                        dataTransaksi[index]['grandTotal'],
                        dataTransaksi[index]['date'],
                        dataTransaksi[index]['status'],
                        dataTransaksi[index],
                        index,
                      );
                    },
                  ),
                  SizedBox(height: 15.0)
                ],
              ),
      ],
    );
  }

  Widget _transaksi(String id, total, date, Status, data, int index) {
    return FadeInDown(
      duration: Duration(milliseconds: 350 * index),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    print(data);
                    Navigator.pushNamed(context, DetailTransaksiPage.routeName,
                        arguments: data);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 113, 110, 110)
                              .withOpacity(0.3), // Shadow color with opacity
                          spreadRadius: 2, // The spread radius of the shadow
                          blurRadius: 10, // The blur radius of the shadow
                          offset:
                              Offset(0, 5), // The position offset of the shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pembayaran Tagihan",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Container(
                                  child: Status == "Pending" ||
                                          Status == 'Ditolak' ||
                                          Status == 'Belum Dibayar' ||
                                          Status == 'Dalam Proses' ||
                                          Status == 'Retur'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                child:
                                                    Status == "Belum Dibayar" ||
                                                            Status ==
                                                                "Dalam Proses" ||
                                                            Status == 'Retur'
                                                        ? Row(
                                                            children: [
                                                              Icon(
                                                                Icons.history,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(Status,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .orange))
                                                            ],
                                                          )
                                                        : Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(Status,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red))
                                                            ],
                                                          ))
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(Status,
                                                style: TextStyle(
                                                    color: Colors.green))
                                          ],
                                        )),
                              Text(
                                date,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Text(
                          CurrencyFormat.convertToIdr(total, 2),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  // mengambil data barang dari API
  Future<String> getData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
    };
    try {
      var url = Uri.parse("${getTransaksi}/${user['_id']}");
      final response = await http.get(url, headers: headers);
      responseJson = json.decode(response.body);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        if (status == true) {
          dataTransaksi = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);
          print(dataTransaksi);
        } else {
          pengembali = true;
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
                    SystemNavigator.pop();
                  },
                  btnOkColor: kColorRedSlow)
              .show();
        });
      }
    }
    return 'success';
  }
}
