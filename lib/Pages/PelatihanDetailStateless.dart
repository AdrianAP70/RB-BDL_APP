import 'package:flutter/material.dart';
import 'package:logins_screen/Pages/PelatihanDetail.dart';
import '../../../../size_config.dart';

class DetailPelatihan extends StatelessWidget {
  static String routeName = "/detail_pelatihan";
  static var dataPelatihan;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    dataPelatihan = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(body: PelatihanDetail());
  }
}
