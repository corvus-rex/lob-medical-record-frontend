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
import 'package:file_picker/file_picker.dart';
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
  bool _devMode = false;
  bool _isSelectedPatient = false;
  Map<String, dynamic> _selectedPatient = {};
  List<dynamic> _patients = [];
  TextEditingController _newBloodType = TextEditingController();
  TextEditingController _newDiastolic = TextEditingController();
  TextEditingController _newSystolic = TextEditingController();
  TextEditingController _newHeight = TextEditingController();
  TextEditingController _newWeight = TextEditingController();
  TextEditingController _newTemp = TextEditingController();
  TextEditingController _newNote = TextEditingController();
  bool _showNewEntryFields = false;
  bool _showNewNotesFields = false;
  TextEditingController _newNoteContent = TextEditingController();
  TextEditingController _newDiagnosis = TextEditingController();
  String? _filePath;

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAccessToken().then((token) => {
      if (token == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed(RoutesName.LOGIN);
        })
      } else {
        setState(() {
          _patients = patientListData['patients'];
        }),
        if (!_devMode) {
          fetchData().then((result) => {
            setState(() {
              _patients = new List.from(_patients)..addAll(result);
              cleanData(_patients);
              print("ALL PATIENTS");
              print(_patients);
            })
          })
        }
      },
    });
  }
  void cleanData(List<dynamic> patientData) {
  for (var patient in patientData) {
    // Convert dob to Unix timestamp if it is a string
    var dob = patient['dob'];
    if (dob is String) {
      try {
        DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(dob);
        int unixTimestamp = parsedDate.millisecondsSinceEpoch ~/ 1000;
        patient['dob'] = unixTimestamp;
      } catch (e) {
        print('Invalid date format for patient ID ${patient['patient_id']}: $dob');
      }
    }

    // Ensure medical_record exists with zero-length clinical_entry and medical_note if missing
    if (patient['medical_record'].length == 0) {
      patient['medical_record'].add({
        'clinical_entry': [],
        'medical_note': []
      });
    }
  }
}

  Future<List<dynamic>> fetchData() async {
    try {
      print(_accessToken == null);
      final response = await http.get(
        Uri.parse(ApiEndpoints.patientList),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'ngrok-skip-browser-warning': "69420",
        },
      );

      // Handle response here
      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
        // Return an empty map or throw an exception based on your requirement
        return []; // or throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error fetching data 1: $error');
      // Return an empty map or throw an exception based on your requirement
      return []; // or throw Exception('Error fetching data: $error');
    }
  }

  Future<String?> _fetchAccessToken() async{
    String? token;
    try {
      String? userDataS = await _storage.read(key: 'user');
      token = await _storage.read(key: 'token');
      if (userDataS != null) {
        _userData = jsonDecode(userDataS);
        // Now userData is a Map<String, dynamic>
        print("aaaaaaaaaaaa" + userDataS + token!);
      } else {
        // Handle the case where the user data is not found in storage
        print('No user data found in storage');
      }
    } catch (e) {
      return null;
    }
    setState(() {
      _userType = _userData['user_type'];
      _accessToken = token;
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
                                print(patient['patient_id']);
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
                          _buildTableRow('No. Pasien:', _selectedPatient!['patient_id']),
                          _buildTableRow('Nama lengkap:', _selectedPatient!['name']),
                          _buildTableRow('Tanggal lahir:', DateTime.fromMillisecondsSinceEpoch(_selectedPatient!['dob'] * 1000).toLocal().toString().substring(0, 10)),
                          _buildTableRow('Nomor Identitas (KTP/SIM):', _selectedPatient!['national_id']),
                          _buildTableRow('No. Handphone:', _selectedPatient!['phone_num']),
                          _buildTableRow('No. Handphone Kerabat:', _selectedPatient!['relative_phone']),
                          _buildTableRow('Alamat:', _selectedPatient!['address']),
                          _buildTableRow('Alias:', _selectedPatient!['alias']),
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
                      _selectedPatient['medical_record'][0]['clinical_entry'] != null
                      ? Container(
                          height: 300, // Adjust height as needed
                          child: DefaultTabController(
                            length: _selectedPatient['medical_record'][0]['clinical_entry'].length,
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
                                            length: _selectedPatient['medical_record'][0]['clinical_entry'].length,
                                            child: Column(
                                              children: [
                                                TabBar(
                                                  indicatorColor: AppColors.element,
                                                  labelColor: AppColors.element,
                                                  isScrollable: true,
                                                  tabs: _selectedPatient['medical_record'][0]['clinical_entry'].map<Tab>((entry) {
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
                                                    children: _selectedPatient['medical_record'][0]['clinical_entry'].map<Widget>((entry) {
                                                      return SingleChildScrollView(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            // Open edit form for this clinical entry
                                                          },
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
                                                            ],
                                                          ),
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
                        )
                      : SizedBox(height: 0,),// Or any other widget you want to show when clinical_entry is null
                      SizedBox(height: 40,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top:20, bottom: 20, left: 0, right: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: AppColors.selected
                        ),
                        onPressed: () {
                          setState(() {
                            _showNewEntryFields = !_showNewEntryFields;
                          });
                        },
                        child: const Text(
                          textAlign: TextAlign.center,
                          "+",
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          )
                        ),
                      ),
                      SizedBox(height: 20,),
                      _showNewEntryFields && (_userType == 2 || _userType == 3 )? 
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _newHeight, // Add text editing controller
                              decoration: InputDecoration(
                                labelText: 'Height (cm)',
                              ),
                            ),
                            TextField(
                              controller: _newWeight, // Add text editing controller
                              decoration: InputDecoration(
                                labelText: 'Weight (kg)',
                              ),
                            ),
                            TextField(
                              controller: _newTemp, // Add text editing controller
                              decoration: InputDecoration(
                                labelText: 'Body Temperature (°C)',
                              ),
                            ),
                            TextField(
                              controller: _newBloodType, // Add text editing controller
                              decoration: InputDecoration(
                                labelText: 'Blood Type',
                              ),
                            ),
                            TextField(
                              controller: _newSystolic, // Add text editing controller
                              decoration: InputDecoration(
                                labelText: 'Systolic (mmHg)',
                              ),
                            ),
                            TextField(
                              controller: _newDiastolic, // Add text editing controller
                              decoration: InputDecoration(
                                labelText: 'Diastolic (mmHg)',
                              ),
                            ),
                            TextField(
                              controller: _newNote, // Add text editing controller
                              decoration: InputDecoration(
                                labelText: 'Note',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Add new clinical entry
                              },
                              child: Text('Save'),
                            ),
                          ],
                        ),
                      ): const SizedBox(height: 0,),
                  
                      const Divider(
                        height: 20,
                        thickness: 2,
                        indent: 20,
                        endIndent: 0,
                        color: AppColors.input,
                      ),
                      SizedBox(height: 40,),
                      const Text(
                        'Rekam dan Catatan Medis',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20,),
                      _selectedPatient['medical_record'][0]['medical_note'] != null
                      ? Container(
                          height: 300, // Adjust height as needed
                          child: DefaultTabController(
                            length: _selectedPatient['medical_record'][0]['medical_note'].length,
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
                                            length: _selectedPatient['medical_record'][0]['medical_note'].length,
                                            child: Column(
                                              children: [
                                                TabBar(
                                                  indicatorColor: AppColors.element,
                                                  labelColor: AppColors.element,
                                                  isScrollable: true,
                                                  tabs: _selectedPatient['medical_record'][0]['medical_note'].map<Tab>((entry) {
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
                                                    children: [
                                                      ..._selectedPatient['medical_record'][0]['medical_note'].map<Widget>((entry) {
                                                        return SingleChildScrollView(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              // Open edit form for this clinical entry
                                                            },
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const SizedBox(height: 20),
                                                                Table(
                                                                  children: [
                                                                    _buildTableRow('Date', DateTime.fromMillisecondsSinceEpoch(entry['date'] * 1000).toLocal().toString().substring(0, 10)),
                                                                    _buildTableRow('Note Content', '${entry['noteContent']}'),
                                                                    _buildTableRow('Diagnosis', '${entry['diagnosis']}'),
                                                                    _buildTableRow('Attachment', '${entry['attachment']}'),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ]
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
                        )
                      : SizedBox(), // Return an empty SizedBox if medical note is null

                      SizedBox(height: 40,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top:20, bottom: 20, left: 0, right: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: AppColors.selected
                        ),
                        onPressed: () {
                          setState(() {
                            _showNewNotesFields = !_showNewNotesFields;
                          });
                        },
                        child: const Text(
                          textAlign: TextAlign.center,
                          "+",
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          )
                        ),
                      ),
                      SizedBox(height: 20,),
                      _showNewNotesFields && (_userType == 1 )? 
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _newNoteContent, // Add text editing controller
                              decoration: InputDecoration(
                                labelText: 'Catatan Medis',
                              ),
                            ),
                            TextField(
                              controller: _newDiagnosis, // Add text editing controller
                              decoration: InputDecoration(
                                labelText: 'Diagnosis',
                              ),
                            ),
                            SizedBox(height: 20,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.only(top:20, bottom: 20, left: 0, right: 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: AppColors.selected
                              ),
                              onPressed: _openFilePicker,
                              child: const Text(
                                textAlign: TextAlign.center,
                                "Upload File",
                                style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                )
                              ),
                            ),
                          ],
                        ),
                      ): const SizedBox(height: 0,),
                  ]
                ),
              )
              )
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String? value) {
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
          child: value != null ? Text(value):Text('None'),
        ),
      ],
    );
  }

}
