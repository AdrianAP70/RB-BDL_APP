import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logins_screen/Pages/Chatbot.dart';
import 'package:logins_screen/Pages/Pelatihan.dart';
import 'package:logins_screen/Pages/Sertifikasi.dart';
import 'package:logins_screen/Screens/Features/USERS/HomeUsers.dart';
import 'package:logins_screen/Screens/Features/USERS/Profile/ProfilePage.dart';
import 'package:logins_screen/Screens/Login/LoginScreens.dart';
import 'package:logins_screen/main.dart';
import 'package:logins_screen/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  static String routeName = "/dashboard";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
                image: AssetImage(
                    "assets/images/logoo.jpg"), // Path to your background image
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()));
                              },
                              child: Icon(
                                Icons.person_pin,
                                color: Colors.white,
                                size: 50,
                              )),
                          Text(
                            user['namaLengkap'],
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            user['noHp'],
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            user['alamat'],
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Apa yang akan kamu jelajahi hari ini?',
                        style: GoogleFonts.getFont('Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(137, 121, 85, 72),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              // padding: EdgeInsets.only(bottom: 10),
                              child: GridView.count(
                                primary: false,
                                padding: const EdgeInsets.only(
                                    top: 50, right: 20, left: 20, bottom: 20),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                children: <Widget>[
                                  // GestureDetector(
                                  //     onTap: () {
                                  //       Navigator.pushNamed(
                                  //           context, HomeUsers.routeName);
                                  //     },
                                  //     child: Container(
                                  //         decoration: BoxDecoration(
                                  //           color: Colors.white,
                                  //           borderRadius:
                                  //               BorderRadius.circular(5),
                                  //         ),
                                  //         padding: EdgeInsets.only(
                                  //             bottom: 30,
                                  //             top: 10,
                                  //             left: 10,
                                  //             right: 10),
                                  //         child: Column(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.center,
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.center,
                                  //           children: [
                                  //             Container(
                                  //               width: double.infinity,
                                  //               height: 80,
                                  //               decoration: BoxDecoration(
                                  //                 image: DecorationImage(
                                  //                   image: AssetImage(
                                  //                       "assets/images/bg-eco.png"), // Path to your background image
                                  //                   fit: BoxFit.cover,
                                  //                 ),
                                  //                 color: Colors.white,
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(5),
                                  //               ),
                                  //               child: Center(
                                  //                 child: Column(
                                  //                   mainAxisAlignment:
                                  //                       MainAxisAlignment
                                  //                           .center,
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment
                                  //                           .center,
                                  //                   children: [],
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             Spacer(),
                                  //             Text(
                                  //               "E-Commerce",
                                  //               textAlign: TextAlign.center,
                                  //               style: Theme.of(context)
                                  //                   .textTheme
                                  //                   .headlineSmall!
                                  //                   .copyWith(
                                  //                     fontSize: 20,
                                  //                     color: Colors.black,
                                  //                     fontWeight:
                                  //                         FontWeight.bold,
                                  //                   ),
                                  //             )
                                  //           ],
                                  //         ))),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, HomeUsers.routeName);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.shopping_bag,
                                              color: Colors.black,
                                              size: 55,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "E-Commerce",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SertifikatHome()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.card_membership,
                                              color: Colors.black,
                                              size: 55,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Sertifikasi",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PelatihanHome()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.design_services,
                                              color: Colors.black,
                                              size: 55,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Pelatihan",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatBot()),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.groups,
                                              color: Colors.black,
                                              size: 55,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Chatbot",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
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
