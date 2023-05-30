import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

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
            content: Text('Failed to submit report. Please try again.'),
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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Data:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      filterData();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
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
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var groupData = filteredData[index];
                    var id = groupData['id'];
                    var groupReports =
                        filteredData.where((data) => data['id'] == id).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Group $id:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: groupReports.length,
                          itemBuilder: (context, index) {
                            var report = groupReports[index];
                            var imageContent = report['img_content'];
                            var imageUrl =
                                'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/' +
                                    imageContent; // Update with your server URL
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${report['id']}'),
                                Text('Lokasi: ${report['lokasi']}'),
                                Text('Gerbang: ${report['gerbang']}'),
                                Text('Pesan: ${report['pesan']}'),
                                Text('Status: ${report['status']}'),
                                Text(
                                    'Date Reported: ${report['date_reported']}'),
                                Text('ID User: ${report['id_user']}'),
                                Image.network(
                                  imageUrl,
                                  width: 200,
                                  height: 200,
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
    );
  }
}
