import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:itsla_maintenance/homepage/ChooseStatus.dart';
import 'package:itsla_maintenance/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'utils.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  // For CircularProgressIndicator.
  bool visible = false;
  late SharedPreferences sharedPreferences;

  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("email") != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChooseStatus(email: sharedPreferences.getString("email")!)));
    }
  }

  Future userLogin() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    // SERVER LOGIN API URL
    var url = 'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/login.php';

    var data = {'email': email, 'password': password};

    // Starting Web API Call.
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    // If the Response Message is Matched.
    if (message == 'Login Matched') {
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Save the email in shared preferences.
      sharedPreferences.setString("email", email);

      // Navigate to Profile Screen.
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChooseStatus(email: emailController.text)));
    } else {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              TextButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return new Scaffold(
      body:SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Container(
          // loginC5C (0:895)
          width: double.infinity,
          height: 844 * fem,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child: Stack(
            children: [
              Positioned(
                // line1QKg (0:896)
                left: 52.2360839844 * fem,
                top: 0 * fem,
                child: Align(
                  child: SizedBox(
                    width: 369.46 * fem,
                    height: 258.71 * fem,
                    child: Image.asset(
                      'assets/images/line-1.png',
                      width: 369.46 * fem,
                      height: 258.71 * fem,
                    ),
                  ),
                ),
              ),
              Positioned(
                // line4UaS (0:897)
                left: 107.6910400391 * fem,
                top: 146.1422119141 * fem,
                child: Align(
                  child: SizedBox(
                    width: 349.79 * fem,
                    height: 445.83 * fem,
                    child: Image.asset(
                      'assets/images/line-4-ftA.png',
                      width: 349.79 * fem,
                      height: 445.83 * fem,
                    ),
                  ),
                ),
              ),
              Positioned(
                // line3Bze (0:898)
                left: 0 * fem,
                top: 0 * fem,
                child: Align(
                  child: SizedBox(
                    width: 192.7 * fem,
                    height: 389.58 * fem,
                    child: Image.asset(
                      'assets/images/line-3-Hkz.png',
                      width: 192.7 * fem,
                      height: 389.58 * fem,
                    ),
                  ),
                ),
              ),
              Positioned(
                // line2iDt (0:899)
                left: 0 * fem,
                top: 196.4212646484 * fem,
                child: Align(
                  child: SizedBox(
                    width: 345.01 * fem,
                    height: 345.27 * fem,
                    child: Image.asset(
                      'assets/images/line-2-Fzn.png',
                      width: 345.01 * fem,
                      height: 345.27 * fem,
                    ),
                  ),
                ),
              ),
              Positioned(
                // rectangle4189oWE (0:901)
                left: 34.3713378906 * fem,
                top: 276.9047851562 * fem,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 1.5 * fem,
                    sigmaY: 1.5 * fem,
                  ),
                  child: Align(
                    child: SizedBox(
                      width: 210.12 * fem,
                      height: 84.19 * fem,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20 * fem),
                          color: Color.fromARGB(244, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // itslamaintenanceTan (0:902)
                left: 43 * fem,
                top: 276.7529296875 * fem,
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
              Positioned(
                // masukkeaplikasimaintancehEE (0:903)
                left: 42.8620605469 * fem,
                top: 338.138671875 * fem,
                child: Align(
                  child: SizedBox(
                    width: 195 * fem,
                    height: 17 * fem,
                    child: Text(
                      'Masuk ke Aplikasi Maintance',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 11 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.5 * ffem / fem,
                        letterSpacing: 1.1 * fem,
                        color: Color(0xff868686),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // rectangle4188Yke (0:904)
                left: 27.2233886719 * fem,
                top: 69.3813476562 * fem,
                child: Align(
                  child: SizedBox(
                    width: 339.84 * fem,
                    height: 174.8 * fem,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10 * fem),
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // cunetnoisescalelevel0x253FQA (0:918)
                left: 53.7900390625 * fem,
                top: 73.3601074219 * fem,
                child: Align(
                  child: SizedBox(
                    width: 286.71 * fem,
                    height: 160.36 * fem,
                    child: Image.asset(
                      'assets/images/logo1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                // rectangle41908yk (12:48)
                left: 0 * fem,
                top: 440.7529296875 * fem,
                child: Align(
                  child: SizedBox(
                    width: 390 * fem,
                    height: 402 * fem,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 251, 251, 251),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20 * fem),
                          topRight: Radius.circular(20 * fem),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x2d000000),
                            offset: Offset(0 * fem, 0 * fem),
                            blurRadius: 7.5 * fem,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // loginmmp (12:49)
                left: 71.5 * fem,
                top: 508.7529296875 * fem,
                child: Align(
                  child: SizedBox(
                    width: 83 * fem,
                    height: 30 * fem,
                    child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 25 * ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.5 * ffem / fem,
                        letterSpacing: 1.6 * fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // belumpunyaakunregisterdUa (12:62)
                left: 117 * fem,
                top: 784 * fem,
                child: Align(
                  child: SizedBox(
                    width: 155 * fem,
                    height: 17 * fem,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5 * ffem / fem,
                            color: Color(0xff000000),
                          ),
                          children: [
                            TextSpan(
                              text: 'Belum Punya Akun? ',
                            ),
                            TextSpan(
                              text: 'Register',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 11 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Color(0xff4285f4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // group52Eop (12:53)
                left: 71.5 * fem,
                top: 580 * fem,
                child: Align(
                  child: SizedBox(
                    width: 248.13 * fem,
                    height: 40 * fem,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10 * fem),
                        border: Border.all(color: Color(0xff909090)),
                        color: Color(0xffffffff),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(
                              7.5 * fem, 50 * fem, 7.5 * fem, 8.25 * fem),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Color(0xff909090)),
                        ),
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
                ),
              ),
              Positioned(
                // group54e6r (12:59)
                left: 71.5 * fem,
                top: 630.6015625 * fem,
                child: Align(
                  child: SizedBox(
                    width: 248.13 * fem,
                    height: 40 * fem,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff909090)),
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(10 * fem),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(
                              7.59 * fem, 50 * fem, 7.02 * fem, 8.85 * fem),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Color(0xff909090)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !isPasswordVisible,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // group51rYN (12:50)
                left: 87 * fem,
                top: 726.2880859375 * fem,
                child: TextButton(
                  onPressed: userLogin,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: 217 * fem,
                    height: 45 * fem,
                    decoration: BoxDecoration(
                      color: Color(0xff4285f4),
                      borderRadius: BorderRadius.circular(30 * fem),
                    ),
                    child: Center(
                      child: Text(
                        'Masuk',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 20 * ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.5 * ffem / fem,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: visible,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              Positioned(
                // lupapasswordsfk (12:65)
                left: 231 * fem,
                top: 674.7529296875 * fem,
                child: Align(
                  child: SizedBox(
                    width: 99 * fem,
                    height: 17 * fem,
                    child: TextButton(
                      onPressed: () {
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Lupa Password?',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12.5 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.5 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}
