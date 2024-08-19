import 'package:flutter/material.dart';
import 'package:logins_screen/Components/BottomNavigationBar/bottom_navigation_users.dart';
import 'package:logins_screen/Components/HomeUsers/HomeUsersScreeens.dart';
import 'package:logins_screen/Screens/Features/USERS/Transaksi/Transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../size_config.dart';
import '../../../main.dart';

class HomeUsers extends StatefulWidget {
  static String routeName = "/home_users";

  @override
  _HomeUsers createState() => _HomeUsers();
}

class _HomeUsers extends State<HomeUsers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _selectedIndex;
  var lastIndex;
  var args;

  _getDataUsers() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    dataUserLogin = sharedPreferences.getString("dataUser");
  }

  getCurrentPage(int index) {
    print(index);
    if (index == 0) {
      return HomeUserComponent();
    } else if (index == 1) {
      return TransaksiPage();
    } else {
      index = 0;
      return HomeUserComponent();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        // args = ModalRoute.of(context)?.settings.arguments;
        // if (args != null) {
        //   // int to = args['to'];
        //   _selectedIndex = args['index'];
        // } else {
        //   _selectedIndex = 0;
        // }
      });
    });
    setState(() {
      this._getDataUsers();
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // Setting up AppBar
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          getCurrentPage(_selectedIndex),
        ],
      ),
      bottomNavigationBar:
          BottomNavigationUsers(_selectedIndex, onTabChange: (index) {
        _selectedIndex = index;
        setState(() {});
        if (_selectedIndex == 1 && _selectedIndex == lastIndex) {}
        lastIndex = index;
      }),
    );
  }
}
