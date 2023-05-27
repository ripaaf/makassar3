import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Report extends StatefulWidget {
  @override
  ReportState createState() => ReportState();
}

class ReportState extends State<Report> {
  List<Map<String, dynamic>> reportData = [];
  List<Map<String, dynamic>> filteredData = [];

  String searchQuery = '';

  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _gerbangController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imgContentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    var url = 'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/fetch_report.php';

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

  Future<void> insertReport(Map<String, dynamic> report) async {
    var url = 'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/insert_report.php';

    var response = await http.post(Uri.parse(url), body: jsonEncode(report));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        // Report inserted successfully
        // Refresh report data to display the new report
        fetchReportData();
      } else {
        // Error occurred while inserting the report
        print('Failed to insert report. Error message: ${result['message']}');
      }
    } else {
      print('Failed to insert report. Error code: ${response.statusCode}');
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

  void _submitReport() {
    Map<String, dynamic> newReport = {
      'lokasi': _lokasiController.text,
      'gerbang': _gerbangController.text,
      'pesan': _pesanController.text,
      'status': _statusController.text,
      'email': _emailController.text,
      'img_content': _imgContentController.text,
    };

    insertReport(newReport);

    // Clear text fields after submitting the report
    _lokasiController.clear();
    _gerbangController.clear();
    _pesanController.clear();
    _statusController.clear();
    _emailController.clear();
    _imgContentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchReportData,
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
                                Text('Image Content: ${report['img_content']}'),
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
                        decoration: InputDecoration(
                          labelText: 'Message',
                        ),
                      ),
                      TextField(
                        controller: _statusController,
                        decoration: InputDecoration(
                          labelText: 'Status',
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextField(
                        controller: _imgContentController,
                        decoration: InputDecoration(
                          labelText: 'Image Content',
                        ),
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
