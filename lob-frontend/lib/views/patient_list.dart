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
  bool _isSelectedPatient = false;
  Map<String, dynamic> _selectedPatient = {};
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
            !_isSelectedPatient ? Expanded(
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
                        DataColumn(label: Text('Nama Lengkap')),
                        DataColumn(label: Text('Sex')),
                        DataColumn(label: Text('Tanggal Lahir')),
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
                                print(patient['patientID']);
                                setState(() {
                                  _selectedPatient = patient;
                                  _isSelectedPatient = true;
                                });
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
            ) : Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Pasien',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40,),
                      Table(
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          _buildTableRow('No. Pasien:', _selectedPatient!['patientID']),
                          _buildTableRow('Nama lengkap:', _selectedPatient!['name']),
                          _buildTableRow('Tanggal lahir:', DateTime.fromMillisecondsSinceEpoch(_selectedPatient!['dob'] * 1000).toLocal().toString().substring(0, 10)),
                          _buildTableRow('Nomor Identitas (KTP/SIM):', _selectedPatient!['nationalID']),
                          _buildTableRow('No. Handphone:', _selectedPatient!['phoneNum']),
                          _buildTableRow('No. Handphone Kerabat:', _selectedPatient!['relativePhone']),
                          _buildTableRow('Alamat:', _selectedPatient!['address']),
                          _buildTableRow('Alias:', _selectedPatient!['alias']),
                          _buildTableRow('Nama asuransi:', _selectedPatient!['insurance']['insurance_name']),
                          _buildTableRow('Jenis kelamin:', _selectedPatient!['sex'] ? 'Laki-laki' : 'Perempuan'),
                        ],
                      ),
                      const Divider(
                        height: 20,
                        thickness: 2,
                        indent: 20,
                        endIndent: 0,
                        color: AppColors.input,
                      ),
                      SizedBox(height: 40,),
                      const Text(
                        'Data Klinis',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        height: 300, // Adjust height as needed
                        child: DefaultTabController(
                          length: _selectedPatient['medicalRecord']['clinicalEntry'].length,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        DefaultTabController(
                                          length: _selectedPatient['medicalRecord']['clinicalEntry'].length,
                                          child: Column(
                                            children: [
                                              TabBar(
                                                indicatorColor: AppColors.element,
                                                labelColor: AppColors.element,
                                                isScrollable: true,
                                                tabs: _selectedPatient['medicalRecord']['clinicalEntry'].map<Tab>((entry) {
                                                  String date = DateTime.fromMillisecondsSinceEpoch(entry['date'] * 1000)
                                                      .toLocal()
                                                      .toString()
                                                      .substring(0, 10);
                                                  return Tab(text: date);
                                                }).toList(),
                                              ),
                                              Container(
                                                height: 300, // Adjust height as needed
                                                child: TabBarView(
                                                  children: _selectedPatient['medicalRecord']['clinicalEntry'].map<Widget>((entry) {
                                                    return SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const SizedBox(height: 20),
                                                          Table(
                                                            children: [
                                                              _buildTableRow('Date', DateTime.fromMillisecondsSinceEpoch(entry['date'] * 1000).toLocal().toString().substring(0, 10)),
                                                              _buildTableRow('Height', '${entry['height']} cm'),
                                                              _buildTableRow('Weight', '${entry['weight']} kg'),
                                                              _buildTableRow('Body Temperature', '${entry['bodyTemp']} °C'),
                                                              _buildTableRow('Blood Type', '${entry['bloodType']}'),
                                                              _buildTableRow('Systolic', '${entry['systolic']} mmHg'),
                                                              _buildTableRow('Diastolic', '${entry['diastolic']} mmHg'),
                                                              _buildTableRow('Note', '${entry['note']}'),
                                                            ],
                                                          ),
                                                        ]
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ]
                ),
              )
              )
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(value),
        ),
      ],
    );
  }

}
