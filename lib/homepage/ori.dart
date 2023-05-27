import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:itsla_maintenance/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  // final String email;

  // HomePage({required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool visible = false;
  String username = '';
  String teknisi = '';

  @override
  void initState() {
    super.initState();
    retrieveData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Username = $username',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: Text( 'mantap',
                    // 'Email = ${widget.email}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Teknisi = $teknisi',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    logout(context);
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text('Logout'),
                ),
                Visibility(
                  visible: visible,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
