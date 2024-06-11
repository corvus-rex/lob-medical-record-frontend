import 'package:lob_frontend/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lob_frontend/components/header.dart';
import 'package:lob_frontend/constants/route_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lob_frontend/constants/patient_list_data.dart';
import 'package:lob_frontend/main.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:lob_frontend/components/video_player.dart';
import 'dart:math';
import 'package:lob_frontend/constants/api_endpoints.dart';
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';

class MyDataPage extends StatefulWidget {
  const MyDataPage({super.key});

  @override
  _MyDataPageState createState() => _MyDataPageState();
}

class _MyDataPageState extends State<MyDataPage> {
  final _storage = const FlutterSecureStorage();
  String? _accessToken; 
  bool _loadFinished = false;
  Map<String, dynamic>? _patientData;
  late Map<String, dynamic> _userData;
  int? _userType;
  late String _patientID;
  bool _devMode = true;

  @override
  void initState() {
    super.initState();
    _fetchAccessToken().then((token) => {
      if (token == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed(RoutesName.LOGIN);
        })
      } else {
      }
    });
    _loadPatientData();
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

  void _loadPatientData() {
    if (_devMode) {
      setState(() {
        _patientData = patientListData['patients'].firstWhere(
          (patient) => patient['patientID'] == _patientID, orElse: () => null
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(padding: const EdgeInsets.all(20), child: Column(
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
          )
          ,_patientData != null
            ? Expanded(
              child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Patient ID: ${_patientData!['patientID']}'),
                  SizedBox(height: 10),
                  Text('Name: ${_patientData!['name']}'),
                  SizedBox(height: 10),
                  Text('Date of Birth: ${DateTime.fromMillisecondsSinceEpoch(_patientData!['dob'] * 1000).toLocal().toString().substring(0, 10)}'),
                  SizedBox(height: 10),
                  Text('National ID: ${_patientData!['nationalID']}'),
                  SizedBox(height: 10),
                  Text('Phone Number: ${_patientData!['phoneNum']}'),
                  SizedBox(height: 10),
                  Text('Address: ${_patientData!['address']}'),
                  SizedBox(height: 10),
                  Text('Alias: ${_patientData!['alias']}'),
                  SizedBox(height: 10),
                  Text('Insurance ID: ${_patientData!['insurance']['insurance_id']}'),
                  SizedBox(height: 10),
                  Text('Insurance Name: ${_patientData!['insurance']['insurance_name']}'),
                  SizedBox(height: 10),
                  Text('Sex: ${_patientData!['sex'] ? 'Male' : 'Female'}'),
                ],
              ),
            )
          )
          : Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            )
          ),
        ],
      ),)
    );
  }
}
