import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logins_screen/Screens/Features/USERS/HomeUsers.dart';
import '../../API/RestApi.dart';
import '../../Screens/Features/USERS/Transaksi/DetailTransaksi.dart';
import '../../utils/constants.dart';

class DetailTransaksiScreens extends StatefulWidget {
  @override
  _DetailTransaksiScreens createState() => _DetailTransaksiScreens();
}

class _DetailTransaksiScreens extends State<DetailTransaksiScreens> {
  var nameFile;
  var nameFile2 = "";
  var misal = 0;

  var namepatch;
  var namepatch2;
  TextEditingController txtcatatan = TextEditingController();

  get http => null;
  String _feedback = '';
  var Rek1 = 'BCA : 8905557870 (Rumah BUMN)';
  var Rek2 = 'BNI : 8905557870 (Rumah BUMN)';
  var Rek3 = 'BRI : 8905557870 (Rumah BUMN)';

  void showDialogRetur() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Retur Barang'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  maxLines: null,
                  controller: txtcatatan,
                  decoration: InputDecoration(
                    hintText: 'Alasan Retur',
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      setState(() async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg', 'png', 'jpeg']);
                        if (result != null) {
                          setState(() {
                            PlatformFile file = result.files.first;
                            nameFile2 = file.name;
                            namepatch2 = file.path;
                            print(namepatch2);
                            Navigator.of(context).pop();
                            showDialogRetur();
                            // _uploadFile2(namepatch);
                          });
                        }
                      });
                    },
                    child: Text(
                      "Gambar $nameFile2",
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                child: Text(
                  'Batal',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                child: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: true,
                    title: 'Apakah Anda Yakin',
                    desc: "Anda yakin melakukan retur barang ?",
                    btnOkOnPress: () async {
                      _uploadFile2(namepatch2);
                    },
                    btnOkIcon: Icons.check,
                    btnOkColor: kColorTealToSlow,
                    btnCancelOnPress: () async {},
                    btnCancelIcon: Icons.cancel,
                    btnCancelColor: kColorRedSlow,
                  ).show();

                  // Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void shoUpload() {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: true,
            title: "Berhasil Upload",
            btnOkOnPress: () {
              Navigator.pushNamed(context, HomeUsers.routeName,
                  arguments: {"index": 1});
            },
            btnOkIcon: Icons.check,
            btnOkColor: Colors.green)
        .show();
  }

  void _copyToClipboard(data) async {
    await Clipboard.setData(ClipboardData(text: data));
    setState(() {
      print("SET");
      AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: "Berhasil Copy",
              desc: data,
              btnOkOnPress: () {},
              btnOkIcon: Icons.check,
              btnOkColor: Colors.green)
          .show();
      _feedback = 'Text copied to clipboard!';
    });
  }

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      setState(() {
        PlatformFile file = result.files.first;
        nameFile = file.name;
        var namePatch = file.path;
        print(namePatch);
        _uploadFile(namePatch);
      });
    }
  }

  void _uploadFile2(filePath) async {
    print(filePath);
    // Get base file name
    // print("File base name:" + fileName.toString());

    try {
      print(filePath);
      Dio dio = new Dio();
      dio.options.headers["Content-Type"] = "multipart/form-data";

      FormData formData = FormData.fromMap({
        "status": "Retur",
        "alasan": txtcatatan.text,
        "fotoretur": await MultipartFile.fromFile(filePath)
      });
      print(FormData);
      print("INI APA BANG");
      // ignore: unused_local_variable
      var url =
          '$transaksiUpdateRetur/${DetailTransaksiPage.dataTransaksi['_id']}';
      print(url);
      final response = await dio.put(url, data: formData);
      print(response);
      AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: 'Berhasil',
              desc: 'Berhasil Upload Retur',
              btnOkOnPress: () {
                Navigator.pushNamed(context, HomeUsers.routeName,
                    arguments: {"index": 1});
              },
              btnOkIcon: Icons.check,
              btnOkColor: kColorGreen)
          .show();
    } catch (e) {
      print("Exception Caught: $e");
    }
  }

  void updateStatus() async {
    // Get base file name
    // print("File base name:" + fileName.toString());

    try {
      Dio dio = new Dio();
      dio.options.headers["Content-Type"] = "multipart/form-data";

      FormData formData = FormData.fromMap({
        "status": "Selesai",
      });

      var url =
          '$transaksiCancelRetur/${DetailTransaksiPage.dataTransaksi['_id']}';
      // ignore: unused_local_variable
      final response = await dio.put(url, data: formData);
      AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: 'Berhasil',
              desc: 'Berhasil Upload Retur',
              btnOkOnPress: () {
                Navigator.pushNamed(context, HomeUsers.routeName,
                    arguments: {"index": 1});
              },
              btnOkIcon: Icons.check,
              btnOkColor: kColorGreen)
          .show();
    } catch (e) {
      print("Exception Caught: $e");
    }
  }

  selectFile2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      setState(() {
        PlatformFile file = result.files.first;
        nameFile2 = file.name;
        namepatch2 = file.path;
        print(namepatch2);

        // _uploadFile2(namepatch);
      });
    }
  }

  void _uploadFile(filePath) async {
    print(filePath);
    // Get base file name
    // print("File base name:" + fileName.toString());

    try {
      print(filePath);
      Dio dio = new Dio();
      dio.options.headers["Content-Type"] = "multipart/form-data";
      FormData formData = FormData.fromMap({
        "status": "Dalam Proses",
        "bukti": await MultipartFile.fromFile(filePath)
      });
      print(FormData);
      print("INI APA BANG");
      // ignore: unused_local_variable
      final response = await dio.put(
          '$transaksiUpdate/${DetailTransaksiPage.dataTransaksi['_id']}',
          data: formData);
      misal = 2;
      shoUpload();
    } catch (e) {
      print("Exception Caught: $e");
    }
  }

  var detailTransaksi = [];

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
    detailTransaksi = DetailTransaksiPage.dataTransaksi['detailTransaksi'];
    if (DetailTransaksiPage.dataTransaksi['bukti'] != null) {
      misal = 2;
    }
  }

  Widget getBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 30),
          child: Text(
            "Tanggal Pesananan ${DetailTransaksiPage.dataTransaksi['date']}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        // tarok disini
        ListView(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            ListView.separated(
              // ignore: unnecessary_null_comparison
              itemCount: detailTransaksi == null ? 0 : detailTransaksi.length,
              shrinkWrap: true,
              primary: false,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 5,
                );
              },
              itemBuilder: (context, index) {
                return _detailTransaksi(
                  "$baseUrl/gambar-barang/${detailTransaksi[index]['barang']['gambar']}",
                  detailTransaksi[index]['barang']['namaBarang'],
                  detailTransaksi[index]['barang']['harga'],
                  detailTransaksi[index]['jumlahBeli'],
                  detailTransaksi[index]['subtotal'],
                  detailTransaksi[index],
                  index,
                );
              },
            ),
            SizedBox(height: 15.0)
          ],
        ),
        Container(
            child: DetailTransaksiPage.dataTransaksi["status"] == "Diterima"
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                        onPressed: () {
                          showDialogRetur();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Ajukan Retur",
                              style: TextStyle(color: Colors.white),
                              // textAlign: TextAlign.center,
                            )
                          ],
                        )))
                : Text("")),
        Container(
            child: DetailTransaksiPage.dataTransaksi["status"] == "Selesai" ||
                    DetailTransaksiPage.dataTransaksi["status"] == "Diterima"
                ? Center(
                    child: Text(
                      "Pesanan Telah Selesai",
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                : Container(
                    child: DetailTransaksiPage.dataTransaksi["status"] ==
                            'Retur'
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Proses Retur Sedang Diajukan',
                                style: TextStyle(color: Colors.green),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextButton(
                                      onPressed: () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.RIGHSLIDE,
                                          headerAnimationLoop: true,
                                          title: 'Yakin Membatalkan Retur',
                                          desc:
                                              "Anda tidak dapat retur barang ini lagi dan status akan berubah menjadi selesai",
                                          btnOkOnPress: () async {
                                            updateStatus();
                                          },
                                          btnOkIcon: Icons.check,
                                          btnOkColor: kColorTealToSlow,
                                          btnCancelOnPress: () async {},
                                          btnCancelIcon: Icons.cancel,
                                          btnCancelColor: kColorRedSlow,
                                        ).show();
                                      },
                                      child: Text(
                                        "Batal Retur",
                                        style: TextStyle(color: Colors.white),
                                      )))
                            ],
                          ))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(216, 11, 133, 233),
                                    borderRadius: BorderRadius.circular(20)),
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Transfer Ke salah satu Rekening dibawah",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$Rek1",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              _copyToClipboard(Rek1);
                                            },
                                            child: Icon(
                                              Icons.note,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("$Rek2",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              _copyToClipboard(Rek2);
                                            },
                                            child: Icon(
                                              Icons.note,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("$Rek3",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              _copyToClipboard(Rek3);
                                            },
                                            child: Icon(
                                              Icons.note,
                                              color: Colors.white,
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    selectFile();
                                  },
                                  child: Text("Upload Bukti Pembayaran")),
                            ],
                          ))),

        SizedBox(height: 15.0),
        Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.width * 1,
            child: misal > 1
                ? Image.network(
                    "$baseUrl/gambar-barang/${DetailTransaksiPage.dataTransaksi['bukti']}",
                  )
                : Text(""))
      ],
    );
  }

  Widget _detailTransaksi(String gambar, String nama, harga, jumlahBeli,
      subTotal, catatan, int index) {
    return FadeInDown(
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
                    top: 10, left: 25, right: 25, bottom: 25),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  CurrencyFormat.convertToIdr(harga, 2),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
                Text(
                  'Catatan ' + DetailTransaksiPage.dataTransaksi["catatan"],
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
