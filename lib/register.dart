import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'login.dart';
import 'utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool isPasswordVisible = false;
  bool visible = false;

  // Getting value from TextField widget.
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final teknisiController = TextEditingController();

  // Validation function for the email field.
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null; // Return null if the input is valid.
  }

  // Validation function for the password field.
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Password';
    }
    return null; // Return null if the input is valid.
  }

  Future<bool> userRegister() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String teknisi = 'true';

    // SERVER REGISTER API URL
    var url = 'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/register.php';

    // Store all data with Param Name.
    var data = {'username': username, 'email': email, 'password': password, 'teknisi': teknisi};

    // Starting Web API Call.
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    // Checking the response status code.
    if (response.statusCode == 200) {
      var message = jsonDecode(response.body);

      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // If the Response Message is "Registration Successful".
      if (message == 'Registration successful') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(message),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            );
          },
        );
        return true;
      } else {
        // If the Response Message is "Email Already Exists".
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(message),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return false;
      }
    } else {
      // Handle the case when the server returns an error status code
      print('Error: ${response.statusCode}');
      return false;
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
          // registerYq4 (0:919)
          width: double.infinity,
          height: 844 * fem,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Stack(
            children: [
              Positioned(
                // line1TBL (0:920)
                left: 52.2360839844 * fem,
                top: 0 * fem,
                child: Align(
                  child: SizedBox(
                    width: 369.46 * fem,
                    height: 258.71 * fem,
                    child: Image.asset(
                      'assets/images/line-1-MXU.png',
                      width: 369.46 * fem,
                      height: 258.71 * fem,
                    ),
                  ),
                ),
              ),
              Positioned(
                // line49pr (0:921)
                left: 107.6910400391 * fem,
                top: 146.1422119141 * fem,
                child: Align(
                  child: SizedBox(
                    width: 349.79 * fem,
                    height: 445.83 * fem,
                    child: Image.asset(
                      'assets/images/line-4.png',
                      width: 349.79 * fem,
                      height: 445.83 * fem,
                    ),
                  ),
                ),
              ),
              Positioned(
                // line35Ci (0:922)
                left: 0 * fem,
                top: 0 * fem,
                child: Align(
                  child: SizedBox(
                    width: 192.7 * fem,
                    height: 389.58 * fem,
                    child: Image.asset(
                      'assets/images/line-3.png',
                      width: 192.7 * fem,
                      height: 389.58 * fem,
                    ),
                  ),
                ),
              ),
              Positioned(
                // line2PUJ (0:923)
                left: 0 * fem,
                top: 196.4212646484 * fem,
                child: Align(
                  child: SizedBox(
                    width: 345.01 * fem,
                    height: 345.27 * fem,
                    child: Image.asset(
                      'assets/images/line-2.png',
                      width: 345.01 * fem,
                      height: 345.27 * fem,
                    ),
                  ),
                ),
              ),
              Positioned(
                // rectangle31vDL (0:924)
                left: 0 * fem,
                top: 440.7529296875 * fem,
                child: Align(
                  child: SizedBox(
                    width: 390 * fem,
                    height: 402 * fem,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
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
                // rectangle4189yBc (0:925)
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
                          color: Color(0xf4ffffff),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // itslamaintenanceEdL (0:926)
                left: 42.5 * fem,
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
                // masukkeaplikasimaintanceWKx (0:927)
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
                // rectangle4188Pee (0:928)
                left: 27.2233886719 * fem,
                top: 69.3813476562 * fem,
                child: Align(
                  child: SizedBox(
                    width: 339.84 * fem,
                    height: 174.8 * fem,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10 * fem),
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // cunetnoisescalelevel0x25274r (0:930)
                left: 53.7912597656 * fem,
                top: 73.357421875 * fem,
                child: Align(
                  child: SizedBox(
                    width: 286.71 * fem,
                    height: 160.36 * fem,
                    child: Image.asset(
                      'assets/images/cunetnoisescalelevel0x25-2-ckW.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                // registercGW (0:931)
                left: 71.5 * fem,
                top: 478 * fem,
                child: Align(
                  child: SizedBox(
                    width: 117 * fem,
                    height: 30 * fem,
                    child: Text(
                      'Register',
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
                // group50kQe (0:938)
                left: 71.5 * fem,
                top: 530 * fem,
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
                        controller: usernameController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(
                              6.5 * fem, 50 * fem, 6.5 * fem, 8.25 * fem),
                          hintText: 'Username',
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
                // group49uWW (0:932)
                left: 87 * fem,
                top: 726.2880859375 * fem,
                child: TextButton(
                  onPressed: userRegister,
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
                        'Buat & Masuk',
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
              Positioned(
                // sudahpunyaakunloginc5U (0:944)
                left: 124.5 * fem,
                top: 784 * fem,
                child: Align(
                  child: SizedBox(
                    width: 141 * fem,
                    height: 17 * fem,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
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
                              text: 'Sudah Punya Akun? ',
                            ),
                            TextSpan(
                              text: 'Login',
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
            ],
          ),
        ),
      ),
      )
    );
  }
}
