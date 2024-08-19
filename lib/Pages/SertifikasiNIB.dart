import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logins_screen/API/RestApi.dart';
import 'package:logins_screen/Pages/Sertifikasi.dart';
import 'package:logins_screen/main.dart';
import 'package:logins_screen/utils/constants.dart';

class SertifikasiNIB extends StatefulWidget {
  @override
  State<SertifikasiNIB> createState() => _SertifikasiNIBState();
}

class _SertifikasiNIBState extends State<SertifikasiNIB> {
  var user = jsonDecode(dataUserLogin);
  get http => null;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  File? _image2;
  var nameFile;
  TextEditingController txtnama = TextEditingController(),
      txtemail = TextEditingController(),
      txtnpwp = TextEditingController(),
      txtalamat = TextEditingController(),
      txtno_hp = TextEditingController(),
      txttgl = TextEditingController(),
      txtstatus = TextEditingController(),
      _imageController = TextEditingController(),
      _imageController2 = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageController.text = _image!.path;
        print("GAMBAR 1");
        print(_image);
      } else {
        print('No Image KTP selected.');
      }
    });
  }

  Future<void> _pickImage2() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image2 = File(pickedFile.path);
        _imageController2.text = _image2!.path;
        print("GAMBAR 2");
        print(_image2);
      } else {
        print('No Image Produk selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    print("Masuk Mana");
    if (_formKey.currentState!.validate() &&
        _image != null &&
        _image2 != null) {
      String getCurrentDateTime() {
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        return formatter.format(now);
      }

      try {
        Dio dio = new Dio();
        dio.options.headers["Content-Type"] = "multipart/form-data";
        FormData formData = FormData.fromMap({
          "userName": user["userName"],
          "Sertifikat": "Sertifikasi NIB",
          "Email": txtemail.text,
          "Nama": txtnama.text,
          "No_NPWP": txtnpwp.text,
          "No_Handphone": txtno_hp.text,
          "tgl": getCurrentDateTime(),
          "status": "Dalam Proses",
          "foto_ktp": await MultipartFile.fromFile(_image!.path),
          "foto_produk": await MultipartFile.fromFile(_image2!.path),
          "file": "",
        });
        print("Masuk SINI");
        // ignore: unused_local_variable
        final response = await dio.post("$sertifikasi", data: formData);
        // print(json.decode(response));
        AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'Berhasil',
                desc: 'Berhasil Input Data',
                btnOkOnPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SertifikatHome()));
                },
                btnOkIcon: Icons.check,
                btnOkColor: kColorGreen)
            .show();
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: Container(
                child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SertifikatHome()));
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )),
            title: Text(
              'Sertifikasi NIB',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 16),
                    TextFormField(
                      controller: txtemail,
                      // keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: txtnama,
                      // keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _imageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Foto tidak boleh kosong!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Gambar Produk',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.image),
                          onPressed: _pickImage,
                        ),
                      ),
                      readOnly: true,
                    ),
                    SizedBox(height: 20),
                    if (_image != null)
                      Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Image.file(
                            _image!,
                            height: 200,
                          ))
                    else
                      Container(),
                    TextFormField(
                      controller: _imageController2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Foto Produk tidak boleh kosong!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Gambar KTP',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.image),
                          onPressed: _pickImage2,
                        ),
                      ),
                      readOnly: true,
                    ),
                    SizedBox(height: 20),
                    if (_image2 != null)
                      Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Image.file(
                            _image2!,
                            height: 200,
                          ))
                    else
                      Container(),
                    TextFormField(
                      controller: txtnpwp,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NPWP tidak boleh kosong!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'NPWP',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: txtno_hp,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'No HP tidak boleh kosong!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'No Handphone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _uploadImage();
                          }
                        },
                        child: Text(
                          'Kirim',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }

  Future<void> selecdate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1700),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        // txttanggallahir.text = _picked.toString().split(" ")[0];
      });
    }
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }
}
