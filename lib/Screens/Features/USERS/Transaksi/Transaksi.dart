import 'package:flutter/material.dart';
import 'package:logins_screen/Components/headers_for_home.dart';
import '../../../../Components/Transaksi/TransaksiScreen.dart';
import '../../../../size_config.dart';

class TransaksiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: HeadersForHome("Transaksi"),
        ),
        body: TransaksiScreens());
  }
}
