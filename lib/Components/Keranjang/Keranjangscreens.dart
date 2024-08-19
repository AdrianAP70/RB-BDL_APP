import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logins_screen/Response/Transaksi.dart';
import '../../API/RestApi.dart';
import '../../Response/Keranjang.dart';
import '../../main.dart';
import '../../utils/constants.dart';

class KerangjangScreens extends StatefulWidget {
  @override
  _KerangjangScreens createState() => _KerangjangScreens();
}

class _KerangjangScreens extends State<KerangjangScreens> {
  var isLoading = false;
  String? Catatan;
  FocusNode focusNode = new FocusNode();
  var responseJson;
  List<Map<String, dynamic>> dataKerangjang = [];
  late bool status = false;
  var user = jsonDecode(dataUserLogin);
  int total = 0;
  int subTotal = 0;
  var pengembali = false;
  TextEditingController txtcatatan = TextEditingController();

  void _catatanDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tuliskan Catatan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  maxLines: null,
                  controller: txtcatatan,
                  decoration: InputDecoration(
                    hintText: 'Catatan Pesanan',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally do something with the input data
                print('Simpan: ${txtcatatan.text}');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget getBody() {
    return ListView(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 30),
            child: Container(
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "Keranjang Anda",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Spacer(),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: pengembali
                          ? Text('')
                          : TextButton(
                              onPressed: () {
                                _catatanDialog();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.note_add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Customize",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              )))
                ],
              ),
            )),
        Container(
            padding: EdgeInsets.only(left: 30),
            child: pengembali
                ? Text(
                    "(Tidak Ada Data)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  )
                : Text('')),
        // tarok disini
        isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: ListView(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      ListView.separated(
                        itemCount:
                            // ignore: unnecessary_null_comparison
                            dataKerangjang == null ? 0 : dataKerangjang.length,
                        shrinkWrap: true,
                        primary: false,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 5,
                          );
                        },
                        itemBuilder: (context, index) {
                          return _keranjang(
                            "$baseUrl/gambar-barang/${dataKerangjang[index]['barang']['gambar']}",
                            dataKerangjang[index]['barang']['namaBarang'],
                            dataKerangjang[index]['barang']['harga'],
                            dataKerangjang[index]['jumlahBeli'],
                            index,
                            dataKerangjang[index]['_id'],
                          );
                        },
                      ),
                      SizedBox(height: 15.0)
                    ],
                  ),
                )),
        SizedBox(
          height: 50,
        ),
        total != 0
            ? Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(total, 2),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            : Container(),
        SizedBox(
          height: 30,
        ),

        total != 0
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextButton(
                    onPressed: () {
                      var x = DateTime.now();
                      final DateFormat formatter =
                          DateFormat('dd-MM-yyyy, HH:mm');
                      final String formatted = formatter.format(x);

                      var data = {
                        'idUser': user['_id'],
                        'grandTotal': total,
                        'date': formatted,
                        'detailTransaksi': dataKerangjang,
                        'status': 'Belum Dibayar',
                        'catatan': txtcatatan.text
                      };
                      TransaksiResponse.inputTransaksiResponse(data, context);
                      print(data);
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          "CHECKOUT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
              )
            : Container()
      ],
    );
  }

  Widget _keranjang(
      String gambar, String nama, harga, jumlahBeli, int index, id) {
    subTotal = harga * jumlahBeli;
    dataKerangjang[index]['subtotal'] = subTotal;
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 113, 110, 110)
                  .withOpacity(0.3), // Shadow color with opacity
              spreadRadius: 2, // The spread radius of the shadow
              blurRadius: 10, // The blur radius of the shadow
              offset: Offset(0, 5), // The position offset of the shadow
            ),
          ],
        ),
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: FadeInDown(
          duration: Duration(milliseconds: 350 * index),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.5,
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 1)
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 110,
                            height: 70,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: NetworkImage(gambar),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      nama,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(harga, 2),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Jumlah Beli $jumlahBeli',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Total " + CurrencyFormat.convertToIdr(subTotal, 2),
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            child: Center(
                                child: GestureDetector(
                          onTap: () {
                            showEditAlert(id);
                          },
                          child: Icon(
                            Icons.edit,
                            color: kColorYellow,
                          ),
                        ))),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            child: Center(
                                child: GestureDetector(
                                    onTap: () {
                                      showHapusAlert(id);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: kColorRedSlow,
                                    ))))
                      ],
                    )
                  ],
                ))
              ],
            ),
          ),
        ));
  }

  showEditAlert(idKeranjang) {
    TextEditingController jmlBeliController = new TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),
            title: Text(
              "Edit Jumlah Beli",
              style: TextStyle(fontSize: 24.0),
            ),
            content: Container(
              height: 200,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: jmlBeliController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Masukan Jumlah Beli Disini',
                            labelText: 'Jumlah Beli'),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          var data = {'jumlahBeli': jmlBeliController.text};
                          KeranjangResponse.updateKeranjangResponse(
                              idKeranjang, data, context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor,
                          // fixedSize: Size(250, 50),
                        ),
                        child: Text(
                          "Submit",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showHapusAlert(idKeranjang) {
    print(idKeranjang);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),
            title: Text(
              "Hapus Keranjang ?",
              style: TextStyle(fontSize: 24.0),
            ),
            content: Container(
              height: 100,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          KeranjangResponse.deleteKeranjangResponse(
                              idKeranjang, context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: kColorRedSlow,
                          // fixedSize: Size(250, 50),
                        ),
                        child: Text(
                          "Submit",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
      var urlpunya = Uri.parse("$getAllKeranjangRes/${user['_id']}");

      final response = await http.get(urlpunya, headers: headers);
      responseJson = json.decode(response.body);
      print(responseJson);
      setState(() {
        isLoading = false;
        status = responseJson['status'];
        if (status == true) {
          dataKerangjang = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);

          for (var i = 0; i < dataKerangjang.length; i++) {
            print(dataKerangjang[i]['jumlahBeli']);
            int jmlBeli = dataKerangjang[i]['jumlahBeli'];
            int harga = dataKerangjang[i]['barang']['harga'];
            total += jmlBeli * harga;
          }
        } else {
          pengembali = true;
          Text("Tidak Ada Data");
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
