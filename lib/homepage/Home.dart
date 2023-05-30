import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:itsla_maintenance/ReportPage/ReportList.dart';
import 'package:itsla_maintenance/ReportPage/viewreworp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../login.dart';
import '../utils.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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
    await TeknisiStatus();
    getTeknisiStatus(teknisi);

    setState(() {
      visible = false;
    });

    // print(teknisi);
  }

  logout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
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
  void initState() {
    retrieveData();
    TeknisiStatus();
    refreshData();
    super.initState();
  }

  Future<void> TeknisiStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmail = sharedPreferences.getString('email') ?? '';

    var url =
        'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/StatusTeknisi.php';

    var data = {'email': savedEmail};

    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      String teknisi = responseData['teknisi'];
      sharedPreferences.setString('teknisi', teknisi);
    } else {
      // Handle error or unexpected response here
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
              // homepagev7p (101:147)
              padding: EdgeInsets.fromLTRB(0 * fem, 40 * fem, 0 * fem, 0 * fem),
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
                        // autogroupasdcU4n (9uBSFJRd3Mc4V2t8AzASdC)
                        margin: EdgeInsets.fromLTRB(
                            21 * fem, 0 * fem, 37 * fem, 44.81 * fem),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // autogroupakdtxVk (9uBSPiMGhhk1QjMaQwakdt)
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 2.5 * fem, 104 * fem, 0 * fem),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // sarahmstaffit5aN (101:160)
                                    margin: EdgeInsets.fromLTRB(0 * fem,
                                        20 * fem, 0 * fem, 19.69 * fem),
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
                                  Container(
                                    // itslamaintenanceafY (101:162)
                                    constraints: BoxConstraints(
                                      maxWidth: 170 * fem,
                                    ),
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
                                ],
                              ),
                            ),
                            Container(
                              // group749gyU (108:13)
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 53.19 * fem),
                              padding: EdgeInsets.fromLTRB(
                                  11 * fem, 11 * fem, 11 * fem, 11 * fem),
                              width: 53 * fem,
                              decoration: BoxDecoration(
                                color: getTeknisiStatus(teknisi),
                                borderRadius: BorderRadius.circular(26.5 * fem),
                              ),
                              child: Center(
                                // ellipse25aZ4 (101:215)
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
                          ],
                        ),
                      ),
                      Container(
                        // autogroupsez4hNn (9uBSashLjCBUv42J7rSEZ4)
                        padding: EdgeInsets.fromLTRB(
                            0 * fem, 0.36 * fem, 0 * fem, 426 * fem),
                        width: double.infinity,
                        height: 654 * fem,
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // group709xJi (101:204)
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 10.1 * fem),
                              padding: EdgeInsets.fromLTRB(
                                  21 * fem, 25.64 * fem, 27 * fem, 38.9 * fem),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // maintancelistSza (101:206)
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 0 * fem, 27 * fem),
                                    child: Text(
                                      'Maintance List',
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
                                    // autogroupeqokMLr (9uBStx1ZJmgcfe9bSveqok)
                                    width: double.infinity,
                                    height: 66 * fem,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReportList()));
                                          },
                                          child: Container(
                                            // group499ge2 (101:207)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                0 * fem, 30 * fem, 0 * fem),
                                            width: 156 * fem,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Color(0xff4285f4),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5 * fem),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x56000000),
                                                  offset:
                                                      Offset(0 * fem, 4 * fem),
                                                  blurRadius: 10 * fem,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Report List',
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 16 * ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.5 * ffem / fem,
                                                  letterSpacing: 1.6 * fem,
                                                  color: Color(0xffffffff),
                                                ),
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
                                                        viewReport()));
                                          },
                                          child: Container(
                                            // group7087US (101:210)
                                            width: 156 * fem,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Color(0xff4285f4),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5 * fem),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x56000000),
                                                  offset:
                                                      Offset(0 * fem, 4 * fem),
                                                  blurRadius: 10 * fem,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                'View Reports',
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 16 * ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.5 * ffem / fem,
                                                  letterSpacing: 1.6 * fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
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
                              // autogroupyaxwxEA (9uBSghrxbKFGSxC8jwYAxW)
                              margin: EdgeInsets.fromLTRB(
                                  21 * fem, 0 * fem, 23.77 * fem, 0 * fem),
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // availableactivitiesVE6 (101:201)
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 72.23 * fem, 0 * fem),
                                    child: Text(
                                      'Available Activities',
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
                                  Text(
                                    // moreCPQ (101:202)
                                    'More',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 13 * ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xffb6b6b6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
