import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:itsla_maintenance/homepage/navbarContainer.dart';
import 'package:itsla_maintenance/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';

class viewReport extends StatefulWidget {
  @override
  viewReportState createState() => viewReportState();
}

class viewReportState extends State<viewReport> {
  bool visible = false;
  List<Map<String, dynamic>> reportData = [];
  List<Map<String, dynamic>> filteredData = [];
  String email = '';
  String username = '';
  String teknisi = '';
  String searchQuery = '';
  String erorcode = '';

  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _gerbangController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;

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
      _emailController.text = savedEmail;
    });
  }

  Future<void> fetchReportData() async {
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
  }

  Future<bool> insertReport(Map<String, dynamic> report) async {
    var url =
        'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/insert_report.php';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add other form fields
    report.forEach((key, value) {
      if (key != 'img_content') {
        request.fields[key] = value.toString();
      }
    });

    // Add the image file
    if (_image != null) {
      var imageField = http.MultipartFile(
        'img_content',
        _image!.readAsBytes().asStream(),
        _image!.lengthSync(),
        filename: 'image.jpg',
      );
      request.files.add(imageField);
    }

    //   print('Request URL: ${request.url}');
    // print('Request Method: ${request.method}');
    // print('Request Fields:');
    // request.fields.forEach((key, value) {
    //   print('$key: $value');
    // });
    // print('Request Files:');
    // request.files.forEach((file) {
    //   print('Field Name: ${file.field}');
    //   print('File Name: ${file.filename}');
    //   print('File Length: ${file.length}');
    // });

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var result = jsonDecode(responseString);
      if (result['status'] == 'success') {
        // Report inserted successfully
        // Refresh report data to display the new report
        refreshData();
        return true; // Return true indicating success
      } else {
        // Error occurred while inserting the report
        print('Failed to insert report. Error message: ${result['message']}');
        erorcode = '${result['message']}';
        return false; // Return false indicating failure
      }
    } else {
      print('Failed to insert report. Error code: ${response.statusCode}');
      return false; // Return false indicating failure
    }
  }

  void filterData() {
    setState(() {
      filteredData = reportData.where((report) {
        final lokasi = report['lokasi'].toString().toLowerCase();
        final gerbang = report['gerbang'].toString().toLowerCase();
        final status = report['status'].toString().toLowerCase();
        final date_reported = report['date_reported'].toString().toLowerCase();

        return lokasi.contains(searchQuery.toLowerCase()) ||
            gerbang.contains(searchQuery.toLowerCase()) ||
            date_reported.contains(searchQuery.toLowerCase()) ||
            status.contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  void _submitReport() async {
    if (_image == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Image not selected'),
            content: Text('Please select an image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    Map<String, dynamic> newReport = {
      'lokasi': _lokasiController.text,
      'gerbang': _gerbangController.text,
      'pesan': _pesanController.text,
      'status': _statusController.text,
      'email': _emailController.text,
    };

    bool success = await insertReport(newReport);
    if (success) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Report submitted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      // Clear text fields and image after submitting the report
      _lokasiController.clear();
      _gerbangController.clear();
      _pesanController.clear();
      _statusController.clear();
      _emailController.clear();
      setState(() {
        _image = null;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit report. Please try again.\n\nEror : $erorcode'),
            
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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
            // reportslistbwk (110:9)
            padding:
                EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 92.88 * fem),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
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
                                      'View Report',
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
                ), //header bagian atas
                StickyHeader(
                  header: Container(
                    margin: EdgeInsets.fromLTRB(
                        6.72 * fem, 50 * fem, 10.72 * fem, 0 * fem),
                    width: double.infinity,
                    height: 43.01 * fem,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20 * fem),
                      color: Color(0xffffffff),
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
                        hintText: 'Search',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20 * fem),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: groupReports.length,
                                      itemBuilder: (context, index) {
                                        var report = groupReports[index];
                                        var imageContent =
                                            report['img_content'];
                                        var imageUrl =
                                            'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/' +
                                                imageContent;
                                        return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // group7266WS (110:29)
                                                margin: EdgeInsets.fromLTRB(
                                                    0 * fem,
                                                    0 * fem,
                                                    0 * fem,
                                                    10.5 * fem),
                                                width: double.infinity,
                                                height: 265 * fem,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      // rectangle4311vnJ (110:31)
                                                      left: 0 * fem,
                                                      top: 0 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 390 * fem,
                                                          height: 265 * fem,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xffffffff),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // lokasiparangloecv2 (110:32)
                                                      left: 29.5 * fem,
                                                      top: 53 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 200 * fem,
                                                          height: 48 * fem,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style:
                                                                  SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize:
                                                                    16 * ffem,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1.5 *
                                                                    ffem /
                                                                    fem,
                                                                color: Color(
                                                                    0xff4285f4),
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Lokasi :\n',
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      '${report['lokasi']}',
                                                                  style:
                                                                      SafeGoogleFont(
                                                                    'Poppins',
                                                                    fontSize:
                                                                        16 *
                                                                            ffem,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1.5 *
                                                                        ffem /
                                                                        fem,
                                                                    color: Color(
                                                                        0xff000000),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // pesanperalatanyangrusakdikaren (110:33)
                                                      left: 30 * fem,
                                                      top: 161 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 160 * fem,
                                                          height: 72 * fem,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style:
                                                                  SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize:
                                                                    12 * ffem,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1.5 *
                                                                    ffem /
                                                                    fem,
                                                                color: Color(
                                                                    0xffb6b6b6),
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Pesan :\n',
                                                                  style:
                                                                      SafeGoogleFont(
                                                                    'Poppins',
                                                                    fontSize:
                                                                        12 *
                                                                            ffem,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1.5 *
                                                                        ffem /
                                                                        fem,
                                                                    color: Color(
                                                                        0xff4285f4),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      '${report['pesan']}',
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // statusmenujulokasi3Ga (110:34)
                                                      left: 30 * fem,
                                                      top: 110 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 85 * fem,
                                                          height: 36 * fem,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style:
                                                                  SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize:
                                                                    12 * ffem,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1.5 *
                                                                    ffem /
                                                                    fem,
                                                                color: Color(
                                                                    0xff000000),
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Status:\n',
                                                                  style:
                                                                      SafeGoogleFont(
                                                                    'Poppins',
                                                                    fontSize:
                                                                        12 *
                                                                            ffem,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1.5 *
                                                                        ffem /
                                                                        fem,
                                                                    color: Color(
                                                                        0xff4285f4),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      'Unknown',
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // maret2023aA2 (110:35)
                                                      left: 285.5 * fem,
                                                      top: 12 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 87 * fem,
                                                          height: 18 * fem,
                                                          child: Text(
                                                            '${report['date_reported']}',
                                                            style:
                                                                SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize:
                                                                  15 * ffem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.5 *
                                                                  ffem /
                                                                  fem,
                                                              color: Color(
                                                                  0xffb6b6b6),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // rectangle4312GHk (110:36)
                                                      left: 30.1513671875 * fem,
                                                      top: 41.5229492188 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 342.25 * fem,
                                                          height: 1.81 * fem,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xfff6f6f6),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // id1b58 (110:37)
                                                      left: 30.5 * fem,
                                                      top: 12 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 60 * fem,
                                                          height: 18 * fem,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style:
                                                                  SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize:
                                                                    14 * ffem,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1.5 *
                                                                    ffem /
                                                                    fem,
                                                                color: Color(
                                                                    0xffb6b6b6),
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: 'Id :',
                                                                  style:
                                                                      SafeGoogleFont(
                                                                    'Poppins',
                                                                    fontSize:
                                                                        14 *
                                                                            ffem,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1.5 *
                                                                        ffem /
                                                                        fem,
                                                                    color: Color(
                                                                        0xff4285f4),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      ' ${report['id']}',
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // rectangle4213Nk6 (110:38)
                                                      left: 260 * fem,
                                                      top: 55 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 112 * fem,
                                                          height: 101 * fem,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5 * fem),
                                                            child:
                                                                Image.network(
                                                              imageUrl,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // rectangle431058i (110:39)
                                                      left: 0 * fem,
                                                      top: 243 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 390 * fem,
                                                          height: 21.99 * fem,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xffe8e8e8),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ), //main show
                                            ]);
                                      })
                                ]);
                          })),
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
        )),
      ),
      floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Transform.scale(
            scale: 1.2,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Insert Report'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              controller: _lokasiController,
                              decoration: InputDecoration(
                                labelText: 'Location',
                              ),
                            ),
                            TextField(
                              controller: _gerbangController,
                              decoration: InputDecoration(
                                labelText: 'Gate',
                              ),
                            ),
                            TextField(
                              controller: _pesanController,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'Message',
                              ),
                            ),
                            DropdownButtonFormField<String>(
                              value: _statusController.text = 'Open',
                              onChanged: (value) {
                                setState(() {
                                  _statusController.text = value!;
                                });
                              },
                              items: ['Open', 'Pending', 'Close'].map((status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'Status',
                              ),
                            ),
                            TextField(
                              controller: _emailController,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: 'reported by',
                              ),
                            ),
                            SizedBox(height: 10),
                            _image != null
                                ? Image.file(_image!)
                                : Text('No image selected'),
                            ElevatedButton(
                              onPressed: _selectImage,
                              child: Text('Select Image'),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _submitReport();
                            Navigator.of(context).pop();
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            ),
          )),
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
