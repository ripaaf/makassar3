import 'dart:ui';
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

  @override
  void initState() {
    super.initState();
    fetchReportData();
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
                    var groupReports = filteredData
                        .where((data) => data['id'] == id)
                        .toList();

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
                            var imageUrl = 'http://0.tcp.ap.ngrok.io:16457/itsla_maintenance/before_maintenance/' + imageContent; // Update with your server URL

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${report['id']}'),
                                Text('Lokasi: ${report['lokasi']}'),
                                Text('Gerbang: ${report['gerbang']}'),
                                Text('Pesan: ${report['pesan']}'),
                                Text('Status: ${report['status']}'),
                                Text('Date Reported: ${report['date_reported']}'),
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
    );
  }
}
