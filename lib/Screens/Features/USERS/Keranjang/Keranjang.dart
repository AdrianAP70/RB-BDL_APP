import 'package:flutter/material.dart';
import 'package:logins_screen/Components/headers_for_home.dart';

import '../../../../Components/Keranjang/Keranjangscreens.dart';
import '../../../../size_config.dart';

class KerangjangPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: HeadersForHome("Keranjang"),
        ),
        body: KerangjangScreens());
  }
}
