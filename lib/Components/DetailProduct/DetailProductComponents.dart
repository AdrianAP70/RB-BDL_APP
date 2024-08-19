import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logins_screen/Components/extentions.dart';

import '../../API/RestApi.dart';
import '../../Response/Keranjang.dart';
import '../../Screens/Features/USERS/DetailProduct/DetailScreens.dart';
import '../../main.dart';
import '../../theme.dart';
import '../../utils/constants.dart';
import '../title_text.dart';


class ProductDetailComponent extends StatefulWidget {
  @override
  _ProductDetailComponent createState() => _ProductDetailComponent();
}

class _ProductDetailComponent extends State<ProductDetailComponent>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  var user = jsonDecode(dataUserLogin);

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(DetailProductscreens.dataBarang);
    return Scaffold(
      floatingActionButton: _flotingButton(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xfffbfbfb),
              Color(0xfff7f7f7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // _appBar(),
                  _productImage(),
                  SizedBox(
                    height: 10,
                  ),
                  _categoryWidget(),
                ],
              ),
              _detailWidget()
            ],
          ),
        ),
      ),
    );
  }


  Widget _productImage() {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(
              "$baseUrl/gambar-barang/${DetailProductscreens.dataBarang['gambar']}",
              height: 305,
              width: 407,
              fit: BoxFit.cover)
        ],
      ),
    );
  }

  Widget _thumbnail(String image) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => AnimatedOpacity(
        opacity: animation.value,
        duration: Duration(milliseconds: 500),
        child: child,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          // Optional: background color for the container
          // color: Theme.of(context).backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13))),
      ),
    );
  }


  Widget _categoryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      width: fullWidth(context),
      height: 80,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _thumbnail(
                "$baseUrl/gambar-barang/${DetailProductscreens.dataBarang['gambar']}"),
          ]),
    );
  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .53,
      minChildSize: .53,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
              .copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(
                          text: DetailProductscreens.dataBarang['namaBarang'],
                          fontSize: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _description(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _description() {
    Color _getStockColor(int stock) {
      if (stock < 10) {
        return Colors.red;
      } else if (stock < 20) {
        return Colors.orange;
      } else if (stock < 100) {
        return Colors.green;
      } else {
        return Colors.blue;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: CurrencyFormat.convertToIdr(
            DetailProductscreens.dataBarang['harga'], 2),
            fontSize: 23,
            color: Colors.blue,
        ),
        SizedBox(height: 0), // Jarak antara harga dan stok
        RichText(
          text: TextSpan(
            text: 'Stok tersisa ',
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: '${DetailProductscreens.dataBarang['stok']}',
                style: TextStyle(
                  color: _getStockColor(DetailProductscreens.dataBarang['stok']),
                ),
              ),
              TextSpan(
                text: ' item!',
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 20), // Jarak antara stok dan keterangan
        Text(DetailProductscreens.dataBarang['keterangan']),
      ],
    );
  }

  FloatingActionButton _flotingButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        showDataAlert();
      },
      backgroundColor: Colors.blue,
      icon: Icon(Icons.shopping_basket, color: Colors.white),
      label: Text(
        '   Beli Produk Ini   ',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  showDataAlert() {
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
              "Masukan Jumlah Beli",
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
                        keyboardType: TextInputType.number,
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
                          // Navigator.of(context).pop();
                          var data = {
                            'idUser': user['_id'],
                            'idBarang': DetailProductscreens.dataBarang['_id'],
                            'jumlahBeli': jmlBeliController.text
                          };
                          KeranjangResponse.inputKeranjangResponse(
                              data, context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue
                            // fixedSize: Size(250, 50),
                            ),
                        child: Text(
                          "Input Keranjang",
                          style: TextStyle(color: Colors.white),
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
}
