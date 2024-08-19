import 'package:flutter/material.dart';
import 'package:logins_screen/Pages/PelatihanTugas.dart';
import 'package:logins_screen/size_config.dart';

class DetailTugas extends StatelessWidget {
  static String routeName = "/detail_tugas";
  static var dataTugas;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    dataTugas = ModalRoute.of(context)!.settings.arguments as String;
    print(dataTugas);
    return Scaffold(body: Tugas());
  }
}
