import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logins_screen/Pages/Admin.dart';
import 'package:logins_screen/Pages/DashboardUser.dart';

import 'package:flutter/material.dart';
import 'package:logins_screen/Pages/SplashScreen.dart';
import 'package:logins_screen/routes.dart';
import 'package:logins_screen/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

var dataUserLogin;
bool? login = false;
void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences;
  sharedPreferences = await SharedPreferences.getInstance();
  login = sharedPreferences.getBool("login");
  String defaultRoutes;
  if (login != null) {
    if (login == false) {
      defaultRoutes = SplashScreen.routeName;
    } else {
      dataUserLogin = sharedPreferences.getString("dataUser");
      var data = jsonDecode(dataUserLogin);
      if (data['role'] == 'user') {
        defaultRoutes = DashboardScreen.routeName;
      } else if (data['role'] == 'admin') {
        defaultRoutes = AdminPage.routeName;
      } else {
        defaultRoutes = SplashScreen.routeName;
      }
    }
  } else {
    defaultRoutes = SplashScreen.routeName;
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'E-Fish',
    theme: theme(),
    initialRoute: defaultRoutes,
    routes: routes,
  ));
  // });
}
