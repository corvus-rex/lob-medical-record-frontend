import 'package:lob_frontend/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:lob_frontend/components/header.dart';
import 'package:lob_frontend/constants/placeholder_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lob_frontend/constants/route_names.dart';
import 'package:lob_frontend/constants/api_endpoints.dart';
import 'package:lob_frontend/constants/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _storage = const FlutterSecureStorage();
  final bool _devMode = true;
  String? _accessToken; 
  TextEditingController _clientID = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _isClicked = false;
  bool? _errLogin;

  @override
  void initState() {
    super.initState();
    _fetchAccessToken().then((token) => {
      print("TOKEN $token"),
      if (token != null) {
        _authenticateToken(token).then((isAuth) {
          if (isAuth != false) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamed(RoutesName.BLANK);
            });
          }
        })
      }
    });
  }

  Future<Map<String, dynamic>> _authenticateToken(String token) async {
    if (_devMode) {
      print("Dev mode is ON. Using dummy data.");
      late Map<String, dynamic> userData;
      switch (token) {
        case 'patient':
          userData = PatientData.toMap();
          break;
        case 'admin':
          userData = AdminData.toMap();
          break;
        case 'doctor':
          userData = DoctorData.toMap();
          break;
        case 'staff':
          userData = StaffData.toMap();
          break;
        default:
          return {'authenticated': false, 'userType': null};
      }
      await _storage.write(key: 'user', value: json.encode(userData));
      return {'authenticated': true, 'userType': userData['userType']};
    } else {
      final response = await http.get(
        Uri.parse(ApiEndpoints.me),
        headers: {
          'X-API-Key': token,
          'ngrok-skip-browser-warning': "69420",
        },
      );

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          print("User authenticated ");
          print(data);

          await _storage.write(key: 'user', value: response.body);
          
          final userType = data['userType'];

          return {'authenticated': true, 'userType': userType};
        } catch (e) {
          print("Error parsing response: $e");
          return {'authenticated': false, 'userType': null};
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return {'authenticated': false, 'userType': null};
      }
    }
  }

  Future<String?> _fetchAccessToken() async{
    String? token = await _storage.read(key: 'token');
    setState(() {
      _accessToken = token; 
    });
    return token;
  }

  Future<void> login(String clientID, String password) async {
  if (_devMode) {
    print("Dev mode is ON. Using dummy data.");

    late Map<String, dynamic> dummyResponse;
    late String dummyToken;
    late int userType;

    if (clientID.contains('patient')) {
      dummyToken = 'patient';
      dummyResponse = PatientData.toMap();
      userType = 4;
    } else if (clientID.contains('doctor')) {
      dummyToken = 'doctor';
      dummyResponse = DoctorData.toMap();
      userType = 2;
    } else if (clientID.contains('staff')) {
      dummyToken = 'staff';
      dummyResponse = StaffData.toMap();
      userType = 3;
    } else if (clientID.contains('admin')) {
      dummyToken = 'admin';
      dummyResponse = AdminData.toMap();
      userType = 1;
    } else {
      _errLogin = true;
      setState(() {
        _accessToken = '';
      });
      return await Future(() => '');
    }

    setState(() {
      _accessToken = dummyToken;
    });
    await _storage.write(key: 'token', value: dummyToken);
    print('New token set: ' + dummyToken);

    await _storage.write(key: 'user', value: json.encode(dummyResponse));
    print('Dummy user data set: ' + json.encode(dummyResponse));

    if (userType == 1) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(RoutesName.PATIENT_REG);
      });
    } else if (userType == 2) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(RoutesName.PATIENT_LIST);
      });
    } else if (userType == 3) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(RoutesName.PATIENT_LIST);
      });
    } else if (userType == 4) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(RoutesName.MY_DATA);
      });
    }

  } else {
    final res = await http.post(
      Uri.parse(ApiEndpoints.login),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'ngrok-skip-browser-warning': "69420",
      },
      body: {'username': clientID, 'password': password},
    );

    Map jsonRes = jsonDecode(res.body);
    print(res);
    if (res.statusCode == 200) {
      setState(() {
        _accessToken = jsonRes["access_token"];
      });
      print(jsonRes);
      await _storage.write(key: 'token', value: jsonRes["access_token"]);
      print('New token set: ' + jsonRes["access_token"]);

      _authenticateToken(jsonRes["access_token"]).then((res) {
        if (res['authenticated']) {
          
          if (res['userType'] == 1) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamed(RoutesName.PATIENT_REG);
            });
          } else if (res['userType'] == 2) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamed(RoutesName.PATIENT_LIST);
            });
          } else if (res['userType'] == 3) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamed(RoutesName.PATIENT_LIST);
            });
          } else if (res['userType'] == 4) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamed(RoutesName.MY_DATA);
            });
          }
        }
      });
    } else {
      _errLogin = true;
      setState(() {
        _accessToken = '';
      });
      return await Future(() => '');
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(padding: const EdgeInsets.all(50), 
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Image.asset('assets/lob_simplified.png'),
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                MediaQuery.of(context).size.width > 1100 ? Container(
                  width: MediaQuery.of(context).size.width*0.4,
                  child: Image.asset('assets/lob.png'),
                ) : const SizedBox(width: 0,),
                MediaQuery.of(context).size.width > 600 ? const SizedBox(width: 120,) : const SizedBox(width: 60,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      textAlign: TextAlign.start,
                      "Login",
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.header,
                      fontSize: 48,
                      )
                    ),
                    const SizedBox(height: 20,),
                    const Text(
                      textAlign: TextAlign.start,
                      "Welcome to Electronic Medical Record System",
                      style: TextStyle(
                      color: AppColors.header,
                      fontSize: 16,
                      )
                    ),
                    const SizedBox(height: 50,),
                    const Text(
                      textAlign: TextAlign.start,
                      "Email",
                      style: TextStyle(
                      color: AppColors.header,
                      fontSize: 14,
                      )
                    ),
                    const SizedBox(height: 5,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width > 1100 ? 
                             MediaQuery.of(context).size.width * 0.4 
                             : MediaQuery.of(context).size.width > 740 ?
                             MediaQuery.of(context).size.width*0.7
                             : MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _clientID,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          fillColor: AppColors.input,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.description),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          hintText: "Enter your email address",
                        ),
                      )
                    ),
                    const SizedBox(height: 20,),
                    const Text(
                      textAlign: TextAlign.start,
                      "Password",
                      style: TextStyle(
                      color: AppColors.header,
                      fontSize: 14,
                      )
                    ),
                    const SizedBox(height: 5,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width > 1100 ? 
                             MediaQuery.of(context).size.width * 0.4 
                             : MediaQuery.of(context).size.width > 740 ?
                             MediaQuery.of(context).size.width*0.7
                             : MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          fillColor: AppColors.input,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.description),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          hintText: "Enter your password",
                          suffixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: ImageIcon(color: AppColors.header, AssetImage('assets/Visibility.png')),
                          ),
                        ),
                      )
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Forgot password?',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.selected, // Set the color of the clickable text
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle the tap on the clickable text (navigate, show a dialog, etc.)
                                print('Forgot password tapped');
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width > 1100 ? 
                             MediaQuery.of(context).size.width * 0.4 
                             : MediaQuery.of(context).size.width > 740 ?
                             MediaQuery.of(context).size.width*0.7
                             : MediaQuery.of(context).size.width * 0.5,
                      child: _isClicked == false ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top:20, bottom: 20, left: 0, right: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: AppColors.selected
                        ),
                        onPressed: () {
                          print("LOGIN: ${_clientID.text}${_password.text}");
                          login(_clientID.text, _password.text);
                        },
                        child: const Text(
                          textAlign: TextAlign.center,
                          "Log in",
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          )
                        ),
                      ) : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top:20, bottom: 20, left: 0, right: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                        },
                        child: const CircularProgressIndicator(color: Colors.white),
                      ) ,
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width > 1100 ? 
                             MediaQuery.of(context).size.width * 0.4 
                             : MediaQuery.of(context).size.width > 740 ?
                             MediaQuery.of(context).size.width*0.7
                             : MediaQuery.of(context).size.width * 0.5,
                      child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        " ",
                        style: TextStyle(
                        color: AppColors.list,
                        fontSize: 14,
                        )
                      ),
                    )),
                    const SizedBox(height: 20,),
                    Container(
                      width: MediaQuery.of(context).size.width > 1100 ? 
                             MediaQuery.of(context).size.width * 0.4 
                             : MediaQuery.of(context).size.width > 740 ?
                             MediaQuery.of(context).size.width*0.7
                             : MediaQuery.of(context).size.width * 0.5,
                      child: Row(
                        children: [
                        ]
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width > 1100 ? 
                             MediaQuery.of(context).size.width * 0.4 
                             : MediaQuery.of(context).size.width > 740 ?
                             MediaQuery.of(context).size.width*0.7
                             : MediaQuery.of(context).size.width * 0.5,
                      child: Align(alignment: Alignment.center, child: 
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: "  ",
                                style: TextStyle(
                                  color: AppColors.list,
                                  fontSize: 14
                                )
                              ),
                            ],
                          ),
                        )
                      ),
                    )],
                )
              ],
            )
          ],
        ),
      )
    )
    );
  }
}