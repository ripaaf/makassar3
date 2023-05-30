import 'package:flutter/material.dart';
import '../utils.dart';
import 'Home.dart';
import 'Profile.dart';
import 'RiwayatPage.dart';

class BottomNavbarContainer extends StatefulWidget {
    final int currentIndex;

  BottomNavbarContainer({required this.currentIndex});

  @override
  BottomNavbarContainerState createState() => BottomNavbarContainerState();
}

class BottomNavbarContainerState extends State<BottomNavbarContainer> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    riwayatPage(),
    Home(),
    Profile(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SingleChildScrollView(
        child: Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            // autogroupejotdZQ (RRMzRzcovqxBmLtPBDEjot)
            padding:
                EdgeInsets.fromLTRB(42 * fem, 14 * fem, 52 * fem, 25 * fem),
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
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: Container(
                    // group748Vbc (108:12)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 1.5 * fem, 0 * fem, 0 * fem),
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
                    setState(() {
                      _currentIndex = 1;
                    });
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
                    setState(() {
                      _currentIndex = 2;
                    });
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
          ), //the bottom navbar
        ), //bottom navbar wrap in
      ),
    );
  }
}
