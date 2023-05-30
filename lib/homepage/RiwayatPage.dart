import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils.dart';

class riwayatPage extends StatefulWidget {
  @override
  riwayatPageState createState() => riwayatPageState();
}

class riwayatPageState extends State<riwayatPage> {
  bool visible = false;
  String email = '';
  String username = '';
  String teknisi = '';
  String statusTeknisi = '';

  retrieveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmail = sharedPreferences.getString('email') ?? '';
    String savedusername = sharedPreferences.getString('username') ?? '';
    String savedteknisi = sharedPreferences.getString('teknisi') ?? '';

    username = savedusername;
    email = savedEmail;
    teknisi = savedteknisi;
  }

  Future<void> refreshData() async {
    setState(() {
      visible = true;
    });

    await retrieveData();

    setState(() {
      visible = false;
    });

    // print(teknisi);
  }

  @override
  void initState() {
    retrieveData();
    // TeknisiStatus();  //teknisi status sudah di panggil di home pertama kali ketika user login
    refreshData();
    super.initState();
  }

  Color getTeknisiStatus(String teknisi) {
    if (teknisi == 'true') {
      return Color(0xff0a9830);
    } else if (teknisi == 'false') {
      return Color(0xffFF0000);
    } else {
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
              // activityJRk (115:14)
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x33ffffff),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/group-474-1-bg.png',
                  ),
                ),
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2 * fem,
                    sigmaY: 2 * fem,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // autogroupwtxcPTC (9uBUpJyfiJEJwczJjQWTXc)
                        width: double.infinity,
                        height: 190 * fem,
                        child: Stack(
                          children: [
                            Positioned(
                              // sarahmstaffitjmx (115:26)
                              left: 21 * fem,
                              top: 55 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 175 * fem,
                                  height: 24 * fem,
                                  child: Text(
                                    '$username',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 16 * ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5 * ffem / fem,
                                      letterSpacing: 1.6 * fem,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              // group750Ren (122:17)
                              left: 300 * fem,
                              top: 40 * fem,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    11 * fem, 11 * fem, 11 * fem, 11 * fem),
                                width: 53 * fem,
                                height: 53 * fem,
                                decoration: BoxDecoration(
                                  color: getTeknisiStatus(teknisi),
                                  borderRadius:
                                      BorderRadius.circular(26.5 * fem),
                                ),
                                child: Center(
                                  // ellipse25v5k (122:19)
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 31 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.5 * fem),
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              // group490rEJ (115:28)
                              left: 21 * fem,
                              top: 93.1904296875 * fem,
                              child: Container(
                                width: 170 * fem,
                                height: 76.81 * fem,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      // activityhistorynNr (115:29)
                                      left: 0 * fem,
                                      top: 59.8095703125 * fem,
                                      child: Align(
                                        child: SizedBox(
                                          width: 102 * fem,
                                          height: 17 * fem,
                                          child: Text(
                                            'Activity History',
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 14 * ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5 * ffem / fem,
                                              letterSpacing: 1.1 * fem,
                                              color: Color(0xff868686),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      // itslamaintenance5cr (115:30)
                                      left: 0 * fem,
                                      top: 0 * fem,
                                      child: Align(
                                        child: SizedBox(
                                          width: 170 * fem,
                                          height: 60 * fem,
                                          child: Text(
                                            'IT SLA MAINTENANCE',
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 20 * ffem,
                                              fontWeight: FontWeight.w700,
                                              height: 1.5 * ffem / fem,
                                              letterSpacing: 2 * fem,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // autogroupte78ZY2 (9uBTtqWmXhG42a7r45tE78)
                        padding: EdgeInsets.fromLTRB(
                            21 * fem, 37.81 * fem, 24 * fem, 293.3 * fem),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // group689TtJ (115:46)
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 21.18 * fem),
                              width: 336 * fem,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(20 * fem),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x3f000000),
                                    offset: Offset(0 * fem, 0 * fem),
                                    blurRadius: 1.5 * fem,
                                  ),
                                ],
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.fromLTRB(15 * fem,
                                      10.19 * fem, 15 * fem, 10.82 * fem),
                                ),
                              ),
                            ),
                            Container(
                              // activityj58 (115:45)
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 25 * fem),
                              child: Text(
                                'Activity',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5 * ffem / fem,
                                  letterSpacing: 2 * fem,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            Container(
                              // group5023Li (115:32)
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 3 * fem, 22.3 * fem),
                              padding: EdgeInsets.fromLTRB(
                                  15.3 * fem, 9.35 * fem, 9 * fem, 16.35 * fem),
                              width: double.infinity,
                              height: 90.7 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10 * fem),
                                gradient: LinearGradient(
                                  begin: Alignment(-0.336, -0.875),
                                  end: Alignment(0.321, 1),
                                  colors: <Color>[
                                    Color(0xff6894de),
                                    Color(0xff568de8),
                                    Color(0xff528bea),
                                    Color(0xff4e89ed),
                                    Color(0xff4285f4)
                                  ],
                                  stops: <double>[0, 0, 0.589, 1, 1],
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // autogroupzj6zFSn (9uBU7AVZXcK5qg28gcZJ6z)
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 61.7 * fem, 0 * fem),
                                    width: 159 * fem,
                                    height: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // finishmaintenancemg2 (115:35)
                                          margin: EdgeInsets.fromLTRB(0 * fem,
                                              0 * fem, 0 * fem, 5 * fem),
                                          child: Text(
                                            'Finish Maintenance',
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5 * ffem / fem,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          // autogroupqerkgHC (9uBUBq2TRJmK4nxQP5qeRk)
                                          margin: EdgeInsets.fromLTRB(0.7 * fem,
                                              0 * fem, 59.3 * fem, 0 * fem),
                                          width: double.infinity,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                // id1Qiz (115:37)
                                                margin: EdgeInsets.fromLTRB(
                                                    0 * fem,
                                                    0 * fem,
                                                    16 * fem,
                                                    0 * fem),
                                                constraints: BoxConstraints(
                                                  maxWidth: 21 * fem,
                                                ),
                                                child: Text(
                                                  'Id : \n1',
                                                  style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12 * ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.5 * ffem / fem,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                // lokasiparangloeuve (115:36)
                                                constraints: BoxConstraints(
                                                  maxWidth: 62 * fem,
                                                ),
                                                child: Text(
                                                  'Lokasi : \nParangloe',
                                                  style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12 * ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.5 * ffem / fem,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // viewdetails3X4 (115:34)
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 5 * fem, 0 * fem, 0 * fem),
                                    child: Text(
                                      'View Details',
                                      style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5 * ffem / fem,
                                        decoration: TextDecoration.underline,
                                        color: Color(0xffffffff),
                                        decorationColor: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // group502N3Y (122:9)
                              margin: EdgeInsets.fromLTRB(
                                  3 * fem, 0 * fem, 0 * fem, 0 * fem),
                              padding: EdgeInsets.fromLTRB(15.3 * fem,
                                  9.35 * fem, 23 * fem, 16.35 * fem),
                              width: 342 * fem,
                              decoration: BoxDecoration(
                                color: Color(0xff4285f4),
                                borderRadius: BorderRadius.circular(10 * fem),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // addedreport4h4 (122:12)
                                    'Added Report',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 16 * ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  Container(
                                    // autogrouplc1ccia (9uBUaZsZtaig3W1yQdLc1C)
                                    margin: EdgeInsets.fromLTRB(
                                        0.7 * fem, 0 * fem, 0 * fem, 0 * fem),
                                    width: 303 * fem,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // no1xGe (122:14)
                                          margin: EdgeInsets.fromLTRB(0 * fem,
                                              5 * fem, 11 * fem, 0 * fem),
                                          constraints: BoxConstraints(
                                            maxWidth: 26 * fem,
                                          ),
                                          child: Text(
                                            'No : \n1',
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5 * ffem / fem,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          // lokasiparangloeefG (122:13)
                                          margin: EdgeInsets.fromLTRB(0 * fem,
                                              5 * fem, 149 * fem, 0 * fem),
                                          constraints: BoxConstraints(
                                            maxWidth: 62 * fem,
                                          ),
                                          child: Text(
                                            'Lokasi : \nParangloe',
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5 * ffem / fem,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          // detailskyC (122:11)
                                          'Details',
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 16 * ffem,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5 * ffem / fem,
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color(0xffffffff),
                                            decorationColor: Color(0xffffffff),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ), //ui for showing the messege of riwayat and home page
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
