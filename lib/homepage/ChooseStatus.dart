import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils.dart';
// import 'Home.dart';
import 'navbarContainer.dart';

class ChooseStatus extends StatefulWidget {
  final String email;

  ChooseStatus({required this.email});

  @override
  ChooseStatusState createState() => ChooseStatusState();
}

class ChooseStatusState extends State<ChooseStatus> {
  bool visible = false;
  String username = '';
  String teknisi = '';
  int StatusTeknisi = 0;

  @override
  void initState() {
    super.initState();
    retrieveData();
    refreshData();
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

  retrieveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmail = sharedPreferences.getString('email') ?? '';

    var url = 'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/retrieve.php';

    var data = {'email': savedEmail};

    var response = await http.post(Uri.parse(url), body: json.encode(data));

    var responseData = jsonDecode(response.body);

    setState(() {
      username = responseData['username'];
      teknisi = responseData['teknisi'];
    });

    sharedPreferences.setString('username', username);
    sharedPreferences.setString('teknisi', teknisi);
  }

  UpdateTeknisi() async {
    setState(() {
    visible = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmail = sharedPreferences.getString('email') ?? '';

    var url =
        'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/teknisi_update.php';

    var data = {
      'email': savedEmail,
      'teknisi': StatusTeknisi == 1 ? 'true' : 'false'
    };

    var response = await http.post(Uri.parse(url), body: json.encode(data));

    var responseData = jsonDecode(response.body);

    // setState(() {
    //   teknisi = responseData['teknisi'];
    // });

    sharedPreferences.setString('teknisi', teknisi);

    if (responseData['message'] == 'Teknisi data updated successfully.') {
      setState(() {
        visible = false;
      });
      // Redirect to the homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavbarContainer(currentIndex: 1,)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return new Scaffold(
      body: SingleChildScrollView(
          child: Container(
        width: double.infinity,
        child: Container(
          // pilihanteknisi1BFU (101:109)
          width: double.infinity,
          decoration: BoxDecoration(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // autogrouppn5lTki (YQVS2GRyRfhMSL1T2Pn5L)
                padding:
                    EdgeInsets.fromLTRB(30 * fem, 35 * fem, 30 * fem, 52 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // welcomebackZHx (101:111)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 34 * fem),
                      constraints: BoxConstraints(
                        maxWidth: 174 * fem,
                      ),
                      child: Text(
                        'Welcome\nBack!',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 36 * ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.5 * ffem / fem,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    Container(
                      // itslamaintenencenRc (101:112)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 10 * fem, 71 * fem, 20 * fem),
                      child: Text(
                        'IT SLA MAINTENENCE',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 25 * ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.5 * ffem / fem,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    Container(
                      // teknisioffmerujukkepadaorangya (101:113)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 72 * fem, 0 * fem),
                      constraints: BoxConstraints(
                        maxWidth: 258 * fem,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.9166666667 * ffem / fem,
                            color: Color(0xffffffff),
                          ),
                          children: [
                            TextSpan(
                              text: 'Teknisi Off',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.9166666667 * ffem / fem,
                                color: Color(0xff000000),
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' Merujuk Kepada orang yang hanya sekedar mengecek informasi terkait maintenance sementara ',
                            ),
                            TextSpan(
                              text: 'Teknisi On',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.9166666667 * ffem / fem,
                                color: Color(0xff000000),
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.9166666667 * ffem / fem,
                                color: Color(0xff00ff44),
                              ),
                            ),
                            TextSpan(
                              text:
                                  'merujuk kepada orang yang turun dan bekerja di lapangan.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // autogroupvcl6XUz (YQURtGdu8FDDGXH5EVCL6)
                padding:
                    EdgeInsets.fromLTRB(30 * fem, 27 * fem, 29 * fem, 62 * fem),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25 * fem),
                    topRight: Radius.circular(25 * fem),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // pilihanteknisiyrn (101:114)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 22 * fem),
                      child: Text(
                        'Pilihan Teknisi',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 20 * ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.5 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // group745Vq8 (101:123)
                      margin: EdgeInsets.fromLTRB(
                          19 * fem, 0 * fem, 8 * fem, 16 * fem),
                      width: double.infinity,
                      height: 46 * fem,
                      child: Container(
                        // autogroupwgsgc94 (YQVGwhE3QcHgSHwpiWGsg)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 1 * fem),
                        padding: EdgeInsets.fromLTRB(
                            6 * fem, 14 * fem, 6 * fem, 8 * fem),
                        width: double.infinity,
                        height: 45 * fem,
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          border: Border(
                              bottom: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 150, 150, 150),
                                  width: 1.0)), // Add a bottom border
                        ),
                        child: Text(
                          ' $username',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5 * ffem / fem,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // group744414 (101:119)
                      margin: EdgeInsets.fromLTRB(
                          19 * fem, 0 * fem, 8 * fem, 36 * fem),
                      width: double.infinity,
                      height: 46 * fem,
                      child: Container(
                        // autogrouphy7tbFt (YQV87cbxmPvng6My3Hy7t)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 1 * fem),
                        padding: EdgeInsets.fromLTRB(
                            6 * fem, 16 * fem, 6 * fem, 8 * fem),
                        width: double.infinity,
                        height: 45 * fem,
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 150, 150, 150),
                                  width: 1.0)), // Add a bottom border
                        ),
                        child: Text(
                          '${widget.email}',
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
                    Center(
                      child: Visibility(
                        visible: visible,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    Container(
                      // masuksebagaiFLS (101:115)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 2 * fem, 26 * fem),
                      child: Text(
                        'Masuk Sebagai',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.5 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // autogroupwegnM8a (YQUhYVDFPuYktEcdXWEGn)
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 47),
                      width: double.infinity,
                      height: 29,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  StatusTeknisi = 0;
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Container(
                                width: 141,
                                height: double.infinity,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: StatusTeknisi == 0
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Teknisi Off',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 3, 17, 0),
                            child: Text(
                              'Or',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Color(0xffb6b6b6),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                StatusTeknisi = 1;
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              width: 141,
                              height: double.infinity,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: StatusTeknisi == 1
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    'Teknisi On',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // group743aJA (101:127)
                      margin: EdgeInsets.fromLTRB(
                          38 * fem, 0 * fem, 40 * fem, 0 * fem),
                      child: TextButton(
                        onPressed: UpdateTeknisi,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 44 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7 * fem),
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
                          child: Center(
                            child: Text(
                              'Masuk',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 20 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5 * ffem / fem,
                                color: Color(0xffffffff),
                              ),
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
      )),
    );
  }
}
