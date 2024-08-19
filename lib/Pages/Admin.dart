import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logins_screen/Screens/Features/USERS/Profile/ProfilePage.dart';
import 'package:logins_screen/Screens/Login/LoginScreens.dart';
import 'package:logins_screen/main.dart';
import 'package:logins_screen/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  static String routeName = "/adminpage";

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();

    main();
  }

  var user = jsonDecode(dataUserLogin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logoo.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hallo,',
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ProfilePage()));
                              },
                              child: Icon(
                                Icons.person_pin,
                                color: Colors.white,
                                size: 50,
                              )),
                          // Text(
                          //   user['namaLengkap'],
                          //   style: GoogleFonts.getFont(
                          //     'Poppins',
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 20,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          SizedBox(height: 8),
                          // Text(
                          //   user['noHp'],
                          //   style: GoogleFonts.getFont(
                          //     'Poppins',
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 18,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          // Text(
                          //   user['alamat'],
                          //   style: GoogleFonts.getFont(
                          //     'Poppins',
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 18,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(137, 121, 85, 72),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Akun anda merupakan akun admin, silahkan kunjungi website untuk mengelola data user",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.WARNING,
                                      animType: AnimType.RIGHSLIDE,
                                      headerAnimationLoop: true,
                                      title: 'Peringatan',
                                      desc: "Yakin ingin keluar",
                                      btnOkOnPress: () async {
                                        final pref = await SharedPreferences
                                            .getInstance();
                                        await pref.clear();
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            LoginScreen.routeName,
                                            (r) => false);
                                      },
                                      btnOkIcon: Icons.check,
                                      btnOkColor: kColorTealToSlow,
                                      btnCancelOnPress: () async {},
                                      btnCancelIcon: Icons.cancel,
                                      btnCancelColor: kColorRedSlow,
                                    ).show();
                                  },
                                  child: Text(
                                    "Keluar",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ))
                          ],
                        ))
                  ],
                ),
              ],
            )));
  }
}

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  DashboardItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color.fromARGB(255, 110, 163, 206),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
