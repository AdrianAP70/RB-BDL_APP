import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logins_screen/Components/extentions.dart';
import 'package:logins_screen/Components/title_text.dart';
import 'package:logins_screen/Pages/DashboardUser.dart';
import 'package:logins_screen/Screens/Features/USERS/Keranjang/Keranjang.dart';
import 'package:logins_screen/main.dart';
import 'package:logins_screen/theme.dart';
import '../../API/RestApi.dart';
import '../../Screens/Features/USERS/DetailProduct/DetailScreens.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;

class HomeUserComponent extends StatefulWidget {
  @override
  _HomeUserComponent createState() => _HomeUserComponent();
}

class _HomeUserComponent extends State<HomeUserComponent> {
  var isLoading = false;
  var totalNotif = 0;
  var responseJson;
  var responseJson2;
  List<Map<String, dynamic>> dataBarang = [];
  List<Map<String, dynamic>> dataKeranjang = [];
  List<Map<String, dynamic>> Kategori = [];
  List<Map<String, dynamic>> _foundBarang = [];
  late bool status = false;
  var user = jsonDecode(dataUserLogin);
  @override
  void initState() {
    super.initState();
    getData();
    getKategori();
    getNotif();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardScreen()));
                },
              ),
              title: AppBar(
                  backgroundColor: Colors.transparent,
                  bottomOpacity: 0.0,
                  elevation: 0.0,
                  toolbarHeight: 100,
                  shadowColor: Colors.white,
                  title: Container(
                      margin: const EdgeInsets.only(left: 1), child: _search()),
                  actions: <Widget>[
                    Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 10, top: 30),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                KerangjangPage()));
                                  },
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.black,
                                  )),
                            )),
                        totalNotif != 0
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
                                    '$totalNotif',
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
                  ]),
            ),
            body: Container(
                child: Container(
              height: MediaQuery.of(context).size.height - 100,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                dragStartBehavior: DragStartBehavior.down,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ayo Belanja',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Rumah BUMN Apps!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Periode Feb - May 2024',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/shopping.png',
                                    height: 100,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Categories
                          Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: _kategoriWidget(),
                          ),
                          SizedBox(height: 16),
                          // Featured Product
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Featured Product',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text('See All'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _productWidget(),
                  ],
                ),
              ),
            ))));
  }

  Widget _icon(IconData icon, {Color color = iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Colors.white,
          boxShadow: shadow),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _productWidget() {
    return Container(
      width: fullWidth(context),
      height: fullHeight(context),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _foundBarang.isEmpty
              ? GridView.builder(
                  // ignore: unnecessary_null_comparison
                  itemCount: dataBarang == null ? 0 : dataBarang.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return _productCard(
                      dataBarang[index]['namaBarang'],
                      "$baseUrl/gambar-barang/${dataBarang[index]['gambar']}",
                      dataBarang[index]['kategori'],
                      CurrencyFormat.convertToIdr(
                        dataBarang[index]['harga'],
                        2,
                      ),
                      dataBarang[index],
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 5,
                  ),
                )
              : GridView.builder(
                  itemCount: _foundBarang == null ? 0 : _foundBarang.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return _productCard(
                      _foundBarang[index]['namaBarang'],
                      "$baseUrl/gambar-barang/${_foundBarang[index]['gambar']}",
                      _foundBarang[index]['kategori'],
                      CurrencyFormat.convertToIdr(
                        _foundBarang[index]['harga'],
                        2,
                      ),
                      _foundBarang[index],
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 5,
                  ),
                ),
    );
  }

  _productCard(name, image, category, price, data) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, DetailProductscreens.routeName,
            arguments: data);
      },
      child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
            ],
          ),
          margin: EdgeInsets.only(top: 20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: kPrimaryColor.withAlpha(40),
                          ),
                          Image.network(image)
                        ],
                      ),
                    ),
                    // SizedBox(height: 5),
                    TitleText(
                      text: name,
                      fontSize: 16,
                    ),
                    TitleText(
                      text: category,
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                    TitleText(
                      text: price.toString(),
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _kategoriWidget() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: isLoading
            ? Center(
                child: Text("Kategori Kosong"),
              )
            : Container(
                height: 50,
                child: ListView.builder(
                  // ignore: unnecessary_null_comparison
                  scrollDirection: Axis.horizontal,
                  itemCount: Kategori == null ? 0 : Kategori.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return _categori(
                      Kategori[index]['namaKategori'],
                    );
                  },
                )));
  }

  _categori(name) {
    return Container(
        margin: EdgeInsets.all(3),
        child: GestureDetector(
            onTap: () {
              // Navigator.pushNamed(context, DetailProductscreens.routeName,
              //     arguments: data);
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget _search() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: lightGrey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                onChanged: (value) => {_runFilter(value)},
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Cari Produk",
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding:
                        EdgeInsets.only(right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getNotif() async {
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
      var responseJson2 = json.decode(response.body);
      print(responseJson2);
      setState(() {
        isLoading = false;
        status = responseJson2['status'];
        if (status == true) {
          dataKeranjang = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);
          totalNotif = dataKeranjang.length;
        } else {
          print("kosong");
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

  // search func
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = dataBarang;
    } else {
      results = dataBarang
          .where((data) => data["namaBarang"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();

      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(() {
      _foundBarang = results;
      print(results);
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
      final response = await http.get(dataBarangRes, headers: headers);
      responseJson = json.decode(response.body);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        if (status == true) {
          dataBarang = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);
        } else {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: responseJson['msg'],
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  onDissmissCallback: (type) {
                    SystemNavigator.pop();
                  },
                  btnOkColor: kColorYellow)
              .show();
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

  Future<String> getKategori() async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
    };

    try {
      final response = await http.get(dataKategori, headers: headers);
      responseJson = json.decode(response.body);

      setState(() {
        isLoading = false;
        status = responseJson['status'];
        if (status == true) {
          Kategori = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);
        } else {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: responseJson['msg'],
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  onDissmissCallback: (type) {
                    SystemNavigator.pop();
                  },
                  btnOkColor: kColorYellow)
              .show();
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

class CategoryButton extends StatelessWidget {
  final String text;

  CategoryButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
