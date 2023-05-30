import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:itsla_maintenance/homepage/navbarContainer.dart';
import 'package:itsla_maintenance/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ReportList extends StatefulWidget {
  @override
  ReportListState createState() => ReportListState();
}

class ReportListState extends State<ReportList> {
  bool visible = false;
  List<Map<String, dynamic>> reportData = [];
  List<Map<String, dynamic>> filteredData = [];
  String email = '';
  String username = '';
  String teknisi = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    retrieveData();
    fetchReportData();
    getTeknisiStatus(teknisi);
  }

  Future<void> refreshData() async {
    setState(() {
      visible = true;
    });

    await retrieveData();
    await fetchReportData();

    setState(() {
      visible = false;
    });
  }

  retrieveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmail = sharedPreferences.getString('email') ?? '';
    String savedusername = sharedPreferences.getString('username') ?? '';
    String savedteknisi = sharedPreferences.getString('teknisi') ?? '';

    setState(() {
      username = savedusername;
      email = savedEmail;
      teknisi = savedteknisi;
    });
  }

  Future<void> fetchReportData() async {
    setState(() {
      visible = true;
    });
    var url =
        'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/fetch_report.php';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        reportData = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        filterData(); // Apply initial filtering
      });
    } else {
      print('Failed to fetch report data. Error code: ${response.statusCode}');
    }

    setState(() {
      visible = false;
    });
  }

  void filterData() {
    setState(() {
      filteredData = reportData.where((report) {
        final lokasi = report['lokasi'].toString().toLowerCase();
        final gerbang = report['gerbang'].toString().toLowerCase();
        final status = report['status'].toString().toLowerCase();
        final dateReported = report['date_reported'].toString().toLowerCase();

        return lokasi.contains(searchQuery.toLowerCase()) ||
            gerbang.contains(searchQuery.toLowerCase()) ||
            dateReported.contains(searchQuery.toLowerCase()) ||
            status.contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  Color getStatusColor(String status) {
    if (status == 'pending') {
      return Colors.yellow;
    } else if (status == 'open') {
      return Colors.blue;
    } else if (status == 'close') {
      return Colors.red;
    } else if (status == 'proses') {
      return Colors.green;
    } else {
      return Colors.transparent;
    }
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
            // homeitreportlistLpe (128:11)
            padding: EdgeInsets.fromLTRB(0 * fem, 35 * fem, 0 * fem, 100 * fem),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0x33ffffff),
              borderRadius: BorderRadius.circular(10 * fem),
            ),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2 * fem,
                  sigmaY: 2 * fem,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                borderRadius: BorderRadius.circular(26.5 * fem),
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
                                          'Home IT',
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
                      // group688eZk (128:119)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 0 * fem),
                      padding: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 6.66 * fem),
                      width: 389.36 * fem,
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StickyHeader(
                              header: Container(
                                // autogroupvm8zKvn (LHv7nHBfnirKAo3b6YVM8z)
                                margin: EdgeInsets.fromLTRB(
                                    9.72 * fem, 50 * fem, 10.72 * fem, 0 * fem),
                                width: double.infinity,
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
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value;
                                      filterData();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        16.55 * fem,
                                        11.03 * fem,
                                        16.55 * fem,
                                        12.1 * fem),
                                    hintText: 'Search',
                                    hintStyle:
                                        TextStyle(color: Color(0xffb6b6b6)),
                                  ),
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 13 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: filteredData.length,
                                  itemBuilder: (context, index) {
                                    var groupData = filteredData[index];
                                    var id = groupData['id'];
                                    var groupReports = filteredData
                                        .where((data) => data['id'] == id)
                                        .toList();
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: groupReports.length,
                                          itemBuilder: (context, index) {
                                            var report = groupReports[index];
                                            return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 389.05 * fem,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          // group670bSN (128:62)
                                                          width: 389.05 * fem,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                // autogroupjtcnY6i (LHv7E3cNy8m8Z2DppyJtcn)
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        0 * fem,
                                                                        0 * fem,
                                                                        0.05 *
                                                                            fem,
                                                                        0.05 *
                                                                            fem),
                                                                width: double
                                                                    .infinity,
                                                                height: 213.46 *
                                                                    fem,
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned(
                                                                      // rectangle4306yUr (128:64)
                                                                      left: 0 *
                                                                          fem,
                                                                      top: 0 *
                                                                          fem,
                                                                      child:
                                                                          Align(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              389 * fem,
                                                                          height:
                                                                              213.46 * fem,
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Color(0xffffffff),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Stack(
                                                                      children: [
                                                                        Positioned(
                                                                          // rectangle43076Ja (128:65)
                                                                          left: 290.5080566406 *
                                                                              fem,
                                                                          top: 64.72265625 *
                                                                              fem,
                                                                          child:
                                                                              Align(
                                                                            child:
                                                                                SizedBox(
                                                                              width: 80.95 * fem,
                                                                              height: 33.38 * fem,
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(10 * fem),
                                                                                  color: getStatusColor(report['status']),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          // menunggut9t (128:68)
                                                                          left: 298.5639648438 *
                                                                              fem,
                                                                          top: 67.4130859375 *
                                                                              fem,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                SizedBox(
                                                                              width: 66 * fem,
                                                                              height: 25 * fem,
                                                                              child: Text(
                                                                                '${report['status']}',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 16 * ffem,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  height: 1.5 * ffem / fem,
                                                                                  color: Color(0xffffffff),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Positioned(
                                                                      // lokasiparangloeCsQ (128:66)
                                                                      left: 30.07421875 *
                                                                          fem,
                                                                      top: 64.72265625 *
                                                                          fem,
                                                                      child:
                                                                          Align(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              150 * fem,
                                                                          height:
                                                                              48 * fem,
                                                                          child:
                                                                              RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              style: SafeGoogleFont(
                                                                                'Poppins',
                                                                                fontSize: 16 * ffem,
                                                                                fontWeight: FontWeight.w500,
                                                                                height: 1.5 * ffem / fem,
                                                                                color: Color(0xff000000),
                                                                              ),
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: 'Lokasi :\n',
                                                                                  style: SafeGoogleFont(
                                                                                    'Poppins',
                                                                                    fontSize: 16 * ffem,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    height: 1.5 * ffem / fem,
                                                                                    color: Color(0xff4285f4),
                                                                                  ),
                                                                                ),
                                                                                TextSpan(
                                                                                  text: '${report['lokasi']}',
                                                                                  style: SafeGoogleFont(
                                                                                    'Poppins',
                                                                                    fontSize: 16 * ffem,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    height: 1.5 * ffem / fem,
                                                                                    color: Color(0xff000000),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      // pesanperalatanygrusakdikarenak (128:67)
                                                                      left: 30.07421875 *
                                                                          fem,
                                                                      top: 113.2080078125 *
                                                                          fem,
                                                                      child:
                                                                          Align(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              198 * fem,
                                                                          height:
                                                                              72 * fem,
                                                                          child:
                                                                              RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              style: SafeGoogleFont(
                                                                                'Poppins',
                                                                                fontSize: 12 * ffem,
                                                                                fontWeight: FontWeight.w500,
                                                                                height: 1.5 * ffem / fem,
                                                                                color: Color(0xff000000),
                                                                              ),
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: 'Pesan :\n',
                                                                                  style: SafeGoogleFont(
                                                                                    'Poppins',
                                                                                    fontSize: 14 * ffem,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    height: 1.5 * ffem / fem,
                                                                                    color: Color(0xff4285f4),
                                                                                  ),
                                                                                ),
                                                                                TextSpan(
                                                                                  text: '${report['pesan']}',
                                                                                  style: SafeGoogleFont(
                                                                                    'Poppins',
                                                                                    fontSize: 12 * ffem,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    height: 1.5 * ffem / fem,
                                                                                    color: Color(0xffb6b6b6),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Image.network(
                                                                    //   imageUrl,
                                                                    //   width: 200,
                                                                    //   height: 200,
                                                                    // ),
                                                                    Positioned(
                                                                      // group671M3U (128:69)
                                                                      left: 309.1901855469 *
                                                                          fem,
                                                                      top: 176.9506835938 *
                                                                          fem,
                                                                      child:
                                                                          Container(
                                                                        width: 78.54 *
                                                                            fem,
                                                                        height: 26.11 *
                                                                            fem,
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              // viewB2W (128:71)
                                                                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 6.28 * fem, 0 * fem),
                                                                              child: Text(
                                                                                'View',
                                                                                style: SafeGoogleFont(
                                                                                  'Poppins',
                                                                                  fontSize: 14 * ffem,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  height: 1.5 * ffem / fem,
                                                                                  color: Color(0xffb6b6b6),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              // 6fG (128:70)
                                                                              width: 20.26 * fem,
                                                                              height: 26.11 * fem,
                                                                              child: Image.asset(
                                                                                'assets/images/-Era.png',
                                                                                width: 20.26 * fem,
                                                                                height: 26.11 * fem,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      // maret20233aW (128:72)
                                                                      left: 284.6762695312 *
                                                                          fem,
                                                                      top: 18.625 *
                                                                          fem,
                                                                      child:
                                                                          Align(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              95 * fem,
                                                                          height:
                                                                              18 * fem,
                                                                          child:
                                                                              Text(
                                                                            '${report['date_reported']}',
                                                                            style:
                                                                                SafeGoogleFont(
                                                                              'Poppins',
                                                                              fontSize: 15 * ffem,
                                                                              fontWeight: FontWeight.w400,
                                                                              height: 1.5 * ffem / fem,
                                                                              color: Color(0xffb6b6b6),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      // rectangle4308xSa (128:73)
                                                                      left: 30.07421875 *
                                                                          fem,
                                                                      top: 48.0024414062 *
                                                                          fem,
                                                                      child:
                                                                          Align(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              341.38 * fem,
                                                                          height:
                                                                              1.81 * fem,
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Color(0xfff6f6f6),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      // id15XC (128:75)
                                                                      left: 30.07421875 *
                                                                          fem,
                                                                      top: 18.625 *
                                                                          fem,
                                                                      child:
                                                                          Align(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              70 * fem,
                                                                          height:
                                                                              18 * fem,
                                                                          child:
                                                                              RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              style: SafeGoogleFont(
                                                                                'Poppins',
                                                                                fontSize: 12 * ffem,
                                                                                fontWeight: FontWeight.w500,
                                                                                height: 1.5 * ffem / fem,
                                                                                color: Color(0xff000000),
                                                                              ),
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: 'Id :',
                                                                                  style: SafeGoogleFont(
                                                                                    'Poppins',
                                                                                    fontSize: 14 * ffem,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    height: 1.5 * ffem / fem,
                                                                                    color: Color(0xff4285f4),
                                                                                  ),
                                                                                ),
                                                                                TextSpan(
                                                                                  text: '${report['id']}',
                                                                                  style: SafeGoogleFont(
                                                                                    'Poppins',
                                                                                    fontSize: 14 * ffem,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    height: 1.5 * ffem / fem,
                                                                                    color: Color(0xffb6b6b6),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                // rectangle4309D18 (128:74)
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        0.05 *
                                                                            fem,
                                                                        0 * fem,
                                                                        0 * fem,
                                                                        0 * fem),
                                                                width: double
                                                                    .infinity,
                                                                height:
                                                                    21.99 * fem,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xffe8e8e8),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),
                                                  )
                                                ]);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ), //sini
                              )),
                          Container(
                            // rectangle4314SZU (128:121)
                            width: double.infinity,
                            height: 1 * fem,
                            decoration: BoxDecoration(
                              color: Color(0xffb6b6b6),
                            ),
                          ),
                          Center(
                            child: Visibility(
                              visible: visible,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                child: CircularProgressIndicator(),
                              ),
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
        )),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        child: Container(
          // autogroupejotdZQ (RRMzRzcovqxBmLtPBDEjot)
          padding: EdgeInsets.fromLTRB(42 * fem, 14 * fem, 42 * fem, 25 * fem),
          width: double.infinity,
          height: 89 * fem,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10 * fem),
              topRight: Radius.circular(10 * fem),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x2d000000),
                offset: Offset(0 * fem, 5 * fem),
                blurRadius: 14 * fem,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavbarContainer(
                              currentIndex: 0,
                            )),
                  );
                },
                child: Container(
                  // group748Vbc (108:12)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 1.5 * fem, 0 * fem, 0 * fem),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // vectorq9g (101:238)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 1 * fem, 4.5 * fem),
                        width: 25 * fem,
                        height: 25 * fem,
                        child: Image.asset(
                          'assets/images/vector.png',
                          width: 25 * fem,
                          height: 25 * fem,
                        ),
                      ),
                      Text(
                        // riwayat9w4 (101:236)
                        'Riwayat',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.5 * ffem / fem,
                          letterSpacing: 1.2 * fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 77 * fem,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavbarContainer(
                              currentIndex: 1,
                            )),
                  );
                },
                child: Container(
                  // group746Hvn (108:10)
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // vector27g (101:237)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 2 * fem),
                        width: 27 * fem,
                        height: 30 * fem,
                        child: Image.asset(
                          'assets/images/vector-2Z4.png',
                          width: 27 * fem,
                          height: 30 * fem,
                        ),
                      ),
                      Text(
                        // homejXt (101:234)
                        'Home',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.5 * ffem / fem,
                          letterSpacing: 1.2 * fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 77 * fem,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavbarContainer(
                              currentIndex: 2,
                            )),
                  );
                },
                child: Container(
                  // group747rMc (108:11)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 3 * fem, 0 * fem, 0 * fem),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // vector11zii (113:5)
                        width: 29 * fem,
                        height: 29 * fem,
                        child: Image.asset(
                          'assets/images/vector-1-1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        // profile8a2 (101:235)
                        'Profile',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.5 * ffem / fem,
                          letterSpacing: 1.2 * fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
