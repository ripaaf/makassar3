import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../login.dart';
import '../utils.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  bool visible = false;
  String email = '';
  String username = '';
  String teknisi = '';

  retrieveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmail = sharedPreferences.getString('email') ?? '';
    String savedusername = sharedPreferences.getString('username') ?? '';
    String savedteknisi = sharedPreferences.getString('teknisi') ?? '';

    username = savedusername;
    email = savedEmail;
    teknisi = savedteknisi;

    print(teknisi);
  }

  Future<void> refreshData() async {
    setState(() {
      visible = true;
    });

    await retrieveData();

    setState(() {
      visible = false;
    });
  }

  logout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    retrieveData();
    refreshData();
    getTeknisiStatus(teknisi);
  }

    Color getTeknisiStatus(String teknisi) {
    if (teknisi == 'true') {
      return Color(0xff0a9830);
    } else if (teknisi == 'false'){
      return Color(0xffFF0000);
    }
    else {
      return Color.fromARGB(0, 0, 0, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Container(
              // profilexii (108:22)
              padding:
                  EdgeInsets.fromLTRB(27 * fem, 14 * fem, 19 * fem, 105 * fem),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // viewlaporanrZC (108:23)
                    margin: EdgeInsets.fromLTRB(
                        259 * fem, 0 * fem, 0 * fem, 9 * fem),
                    child: Text(
                      'VIEW LAPORAN',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 10 * ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.5 * ffem / fem,
                        letterSpacing: 0.8 * fem,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  Container(
                    // group750kuU (108:58)
                    margin: EdgeInsets.fromLTRB(
                        87 * fem, 0 * fem, 95 * fem, 75 * fem),
                    padding: EdgeInsets.fromLTRB(
                        33.62 * fem, 33.62 * fem, 33.62 * fem, 33.62 * fem),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: getTeknisiStatus(teknisi),
                      borderRadius: BorderRadius.circular(81 * fem),
                    ),
                    child: Center(
                      // ellipse25FrE (108:60)
                      child: SizedBox(
                        width: 94.75 * fem,
                        height: 94.75 * fem,
                        child: Image.asset(
                          'assets/images/ellipse-25.png',
                          width: 94.75 * fem,
                          height: 94.75 * fem,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // useratW (108:34)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 312 * fem, 0 * fem),
                    child: Text(
                      'User',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.5 * ffem / fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    // group4106rr (108:31)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 7 * fem, 6.76 * fem),
                    padding: EdgeInsets.fromLTRB(
                        6 * fem, 13 * fem, 6 * fem, 11.24 * fem),
                    width: 337 * fem,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffc8c8c8)),
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(6 * fem),
                    ),
                    child: Text(
                      '$username',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.5 * ffem / fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    // emailwsU (108:35)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 300 * fem, 0 * fem),
                    child: Text(
                      'Email',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.5 * ffem / fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    // group473GPx (108:36)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 5 * fem, 279.76 * fem),
                    width: 335 * fem,
                    height: 45.24 * fem,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6 * fem),
                    ),
                    child: Container(
                      // group412PUa (108:37)
                      padding: EdgeInsets.fromLTRB(
                          4 * fem, 13 * fem, 4 * fem, 11.24 * fem),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffc8c8c8)),
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(6 * fem),
                      ),
                      child: Text(
                        '$email',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.5 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      logout(context);
                    },
                    child: Container(
                      // group49TjL (108:25)
                      margin: EdgeInsets.fromLTRB(
                          98 * fem, 0 * fem, 106 * fem, 0 * fem),
                      width: double.infinity,
                      height: 45 * fem,
                      decoration: BoxDecoration(
                        color: Color(0xff4285f4),
                        borderRadius: BorderRadius.circular(30 * fem),
                      ),
                      child: Center(
                        child: Text(
                          'Log Out',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 17 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.5 * ffem / fem,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
