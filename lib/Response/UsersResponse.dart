import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logins_screen/Pages/DashboardUser.dart';
import 'package:logins_screen/Screens/Login/LoginScreens.dart';
import 'package:logins_screen/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logins_screen/utils/utils_apps.dart';
import 'package:logins_screen/utils/constants.dart';

import '../API/RestApi.dart';

bool status = false;
var responseJson;
var dataUser = {};

class LoginResponse {
  static void loginResponse(data, BuildContext context) async {
    utilsApps.showDialog(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    print(jsonEncode(data));
    try {
      final response =
          await http.post(signIn, headers: headers, body: jsonEncode(data));
      responseJson = json.decode(response.body);
      status = responseJson['status'];
      // code = responseJson['code'];
      print(responseJson);
      print("IANSINASIAS AIS ");
      // print(code);
      if (status == true) {
        dataUser = responseJson['data'];
        print(dataUser);
        sharedPreferences.setString('dataUser', jsonEncode(dataUser));
        sharedPreferences.setBool('login', true);
        sharedPreferences.commit();
        main();
        Future.delayed(Duration(seconds: 1)).then((value) {
          utilsApps.hideDialog(context);
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Berhasil',
                  desc: responseJson['msg'],
                  btnOkOnPress: () {
                    print("USERHH: "); print(dataUser);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => main()));
                    Navigator.pushNamed(context, DashboardScreen.routeName,
                        arguments: dataUser);
                  },
                  btnOkIcon: Icons.check,
                  btnOkColor: Colors.green)
              .show();
        });
      } else {
        Future.delayed(Duration(seconds: 1)).then((value) {
          utilsApps.hideDialog(context);
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: responseJson['msg'],
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  btnOkColor: kColorYellow)
              .show();
          // utilsApps.dengerSnack(context, responseJson['message']);
        });
      }
      // print(dataUser);
    } catch (e) {
      print(e);
      Future.delayed(Duration(seconds: 1)).then((value) {
        utilsApps.hideDialog(context);
        AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'Peringatan',
                desc: "Terjadi kesalahan pada server",
                btnOkOnPress: () {},
                btnOkIcon: Icons.cancel,
                btnOkColor: kColorRedSlow)
            .show();
      });
    }
  }

  static void registerResponse(data, BuildContext context) async {
    utilsApps.showDialog(context);
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    print(jsonEncode(data));
    try {
      var response =
          await http.post(signUp, headers: headers, body: jsonEncode(data));
      responseJson = json.decode(response.body);
      status = responseJson['status'];
      // code = responseJson['code'];
      print(responseJson);
      if (status == true) {
        Future.delayed(Duration(seconds: 1)).then((value) {
          utilsApps.hideDialog(context);
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: responseJson['msg'],
                  btnOkOnPress: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  btnOkIcon: Icons.check,
                  btnOkColor: kPrimaryColor)
              .show();
        });
      } else {
        Future.delayed(Duration(seconds: 1)).then((value) {
          utilsApps.hideDialog(context);
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Peringatan',
                  desc: responseJson['msg'],
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  btnOkColor: kColorYellow)
              .show();
          // utilsApps.dengerSnack(context, responseJson['message']);
        });
      }
      // print(dataUser);
    } catch (e) {
      print(e);
      Future.delayed(Duration(seconds: 1)).then((value) {
        utilsApps.hideDialog(context);
        AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: 'Peringatan',
                desc: "Terjadi kesalahan pada server",
                btnOkOnPress: () {},
                btnOkIcon: Icons.cancel,
                btnOkColor: kColorRedSlow)
            .show();
      });
    }
  }
}
