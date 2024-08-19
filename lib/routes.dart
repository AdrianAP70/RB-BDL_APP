import 'package:flutter/cupertino.dart';
import 'package:logins_screen/Pages/Admin.dart';
import 'package:logins_screen/Pages/DashboardUser.dart';
import 'package:logins_screen/Pages/PelatihanDetailMateri.dart';
import 'package:logins_screen/Pages/PelatihanDetailStateless.dart';
import 'package:logins_screen/Pages/SplashScreen.dart';
import 'package:logins_screen/Pages/TugasStatles.dart';
import 'package:logins_screen/Screens/Features/USERS/HomeUsers.dart';
import 'package:logins_screen/Screens/Login/LoginScreens.dart';
import 'Screens/Features/USERS/DetailProduct/DetailScreens.dart';
import 'Screens/Features/USERS/Transaksi/DetailTransaksi.dart';
import 'Screens/Registrasi/RegistrasiScreens.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  RegistrasiScreen.routeName: (context) => RegistrasiScreen(),
  HomeUsers.routeName: (context) => HomeUsers(),
  SplashScreen.routeName: (context) => SplashScreen(),
  DashboardScreen.routeName: (context) => DashboardScreen(),
  AdminPage.routeName: (context) => AdminPage(),
  DetailProductscreens.routeName: (context) => DetailProductscreens(),
  DetailTransaksiPage.routeName: (context) => DetailTransaksiPage(),
  DetailPelatihan.routeName: (context) => DetailPelatihan(),
  DetailMateri.routeName: (context) => DetailMateri(),
  DetailTugas.routeName: (context) => DetailTugas(),
};
