import 'package:lob_frontend/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lob_frontend/components/header.dart';
import 'package:lob_frontend/constants/route_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lob_frontend/main.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:lob_frontend/components/video_player.dart';
import 'dart:math';
import 'package:lob_frontend/constants/api_endpoints.dart';
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';

class RegPatientPage extends StatefulWidget {
  const RegPatientPage({super.key});

  @override
  _RegPatientPageState createState() => _RegPatientPageState();
}

class _RegPatientPageState extends State<RegPatientPage> {
  final _storage = const FlutterSecureStorage();
  String? _accessToken; 
  bool _loadFinished = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _relativePhoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _pobController = TextEditingController();
  final TextEditingController _insuranceController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isMale = true;
  int? _dobUnixTimestamp;

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
  }

  Future<String?> _fetchAccessToken() async{
    String? token;
    try {
      token = await _storage.read(key: 'token');
    } catch (e) {
      return null;
    }
    setState(() {
      _accessToken = token;
    });
    return token;
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
          ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _nameController,
                              labelText: 'Nama Lengkap',
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildDropdownButtonFormField(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _phoneController,
                              labelText: 'No. Handphone',
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _relativePhoneController,
                              labelText: 'No. Handphone Kerabat',
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _dobController,
                              labelText: 'Tanggal lahir',
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    _dobUnixTimestamp = pickedDate.millisecondsSinceEpoch ~/ 1000;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildTextField(
                              controller: _pobController,
                              labelText: 'Tempat Lahir',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _nationalIdController,
                              labelText: 'Nomor Identitas (KTP/SIM)',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _addressController,
                              labelText: 'Alamat',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _insuranceController,
                              labelText: 'Jenis Asuransi',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      _buildTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirm Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final formData = {
                                'name': _nameController.text,
                                'dob': _dobUnixTimestamp,
                                'nationalId': _nationalIdController.text,
                                'address': _addressController.text,
                                'sex': _isMale ? 1 : 0,
                                'password': _passwordController.text,
                              };
                              print('Form Data: $formData');
                              // Handle form submission here
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
      ),)
    );
  }
  

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool readOnly = false,
    bool obscureText = false,
    Function()? onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscureText,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          if (labelText == 'Confirm Password' && value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownButtonFormField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<bool>(
        value: _isMale,
        decoration: InputDecoration(
          labelText: 'Jenis kelamin',
          border: InputBorder.none,
        ),
        items: [
          DropdownMenuItem(
            child: Text('Laki-laki'),
            value: true,
          ),
          DropdownMenuItem(
            child: Text('Perempuan'),
            value: false,
          ),
        ],
        onChanged: (value) {
          setState(() {
            _isMale = value!;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select your sex';
          }
          return null;
        },
      ),
    );
  }

  
}
