import 'package:lob_frontend/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lob_frontend/components/header.dart';
import 'package:lob_frontend/constants/route_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lob_frontend/main.dart';
import 'package:flutter/scheduler.dart';
import 'package:lob_frontend/constants/patient_list_data.dart';
import 'package:http/http.dart' as http;
import 'package:lob_frontend/constants/api_endpoints.dart';
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final _storage = const FlutterSecureStorage();
  String? _accessToken; 
  int? _userType;
  late Map<String, dynamic> _userData;
  bool _loadFinished = false;
  bool _devMode = true;
  List<Map<String, dynamic>> _patients = [];

  @override
  void initState() {
    super.initState();
    if (_devMode) {
      setState(() {
        _patients = _sortPatientsByName(patientListData['patients']);
      });
    }
    _fetchAccessToken().then((token) => {
      if (token == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed(RoutesName.LOGIN);
        })
      } else {
      }
    });
  }

  List<Map<String, dynamic>> _sortPatientsByName(List<Map<String, dynamic>> patients) {
    patients.sort((a, b) => a['name'].compareTo(b['name']));
    return patients;
  }

  Future<String?> _fetchAccessToken() async{
    String? token;
    try {
      String? userDataS = await _storage.read(key: 'user');
      token = await _storage.read(key: 'token');
      if (userDataS != null) {
        _userData = jsonDecode(userDataS);
        // Now userData is a Map<String, dynamic>
        print(userDataS);
      } else {
        // Handle the case where the user data is not found in storage
        print('No user data found in storage');
      }
    } catch (e) {
      return null;
    }
    setState(() {
      _userType = _userData['userType'];
    });
    return token;
  }
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            const SizedBox(height: 50,),
            const Divider(
              height: 20,
              thickness: 2,
              indent: 20,
              endIndent: 0,
              color: AppColors.input,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.element),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Sex')),
                        DataColumn(label: Text('DOB')),
                        DataColumn(label: Text('Action')), // New column for the buttons
                        if (_userType == 1)
                          DataColumn(label: Text('Edit')),
                        if (_userType == 2 || _userType == 3)
                          DataColumn(label: Text('Medical Record')), // New column for the medical record button
                        if (_userType == 2 || _userType == 3)
                          DataColumn(label: Text('Bookmark')), // New column for the bookmark button
                      ],
                      rows: _patients.map((patient) {
                        List<DataCell> cells = [
                          DataCell(Text(patient['name'])),
                          DataCell(Text(patient['sex'] ? 'Male' : 'Female')),
                          DataCell(Text(
                            DateTime.fromMillisecondsSinceEpoch(patient['dob'] * 1000)
                                .toLocal()
                                .toIso8601String()
                                .substring(0, 10),
                          )),
                          DataCell( // Custom cell for the action buttons
                            ElevatedButton(
                              onPressed: () {
                                // Handle button press, e.g., navigate to detail page
                              },
                              child: Text('See Detail'),
                            ),
                          ),
                        ];
                        if (_userType == 1) {
                          cells.add(DataCell( // Custom cell for the edit button
                            ElevatedButton(
                              onPressed: () {
                                // Handle edit button press
                              },
                              child: Text('Edit'),
                            ),
                          ));
                        }
                        if (_userType == 2 || _userType == 3) {
                          cells.add(DataCell( // Custom cell for the medical record button
                            ElevatedButton(
                              onPressed: () {
                                // Handle medical record button press
                              },
                              child: Text('Medical Record'),
                            ),
                          ));

                          cells.add(DataCell( // Custom cell for the bookmark button
                            ElevatedButton(
                              onPressed: () {
                                // Handle bookmark button press
                              },
                              child: Text('Bookmark'),
                            ),
                          ));
                        }

                        return DataRow(cells: cells);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
