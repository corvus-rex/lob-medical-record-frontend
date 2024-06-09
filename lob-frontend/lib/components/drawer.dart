import 'package:flutter/material.dart';
import 'package:lob_frontend/constants/app_color.dart';
import 'package:lob_frontend/constants/route_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/scheduler.dart';
import 'dart:convert';

class MyDrawer extends StatefulWidget {
  final String routeName;

  const MyDrawer({
    Key? key,
    required this.routeName,
  }) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final _storage = const FlutterSecureStorage();
  int? _userType;
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _fetchAccessToken().then((token) => {
      if (token == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed(RoutesName.LOGIN);
        })
      } else {
        // token checking N/A
      }
    });
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
    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(30),
        color: const Color(0xFFF6F8FB),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              textAlign: TextAlign.start,
              "Dashboard",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.header,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 30),
            if (_userType == 1)
              Container(
                decoration: widget.routeName == RoutesName.PATIENT_REG
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                        color: AppColors.selectedBG,
                      )
                    : null,
                margin: const EdgeInsets.only(top: 10),
                child: ListTile(
                  leading: widget.routeName == RoutesName.PATIENT_REG ||
                          widget.routeName == '/patient/register'
                      ? const ImageIcon(
                          color: AppColors.selected,
                          AssetImage('assets/Home_Selected.png'),
                        )
                      : const ImageIcon(AssetImage('assets/Home.png')),
                  title: Text(
                    'Daftar Pasien',
                    style: TextStyle(
                      color: widget.routeName == RoutesName.PATIENT_REG ||
                              widget.routeName == '/patient/register'
                          ? AppColors.selected
                          : AppColors.list,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.PATIENT_REG);
                  },
                ),
              ),
              if (_userType == 1 || _userType == 2 || _userType == 3)
                Container(
                  decoration: widget.routeName == RoutesName.PATIENT_LIST
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                          color: AppColors.selectedBG,
                        )
                      : null,
                  margin: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    leading: widget.routeName == RoutesName.PATIENT_LIST ||
                            widget.routeName == '/patient/list'
                        ? const ImageIcon(
                            color: AppColors.selected,
                            AssetImage('assets/Home_Selected.png'),
                          )
                        : const ImageIcon(AssetImage('assets/Home.png')),
                    title: Text(
                      'Semua Pasien',
                      style: TextStyle(
                        color: widget.routeName == RoutesName.PATIENT_LIST ||
                                widget.routeName == '/patient/list'
                            ? AppColors.selected
                            : AppColors.list,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.PATIENT_LIST);
                    },
                  ),
                ),
            const SizedBox(height: 30),
              if (_userType == 4)
                Container(
                  decoration: widget.routeName == RoutesName.MY_DATA
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                          color: AppColors.selectedBG,
                        )
                      : null,
                  margin: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    leading: widget.routeName == RoutesName.MY_DATA ||
                            widget.routeName == '/patient/me'
                        ? const ImageIcon(
                            color: AppColors.selected,
                            AssetImage('assets/Home_Selected.png'),
                          )
                        : const ImageIcon(AssetImage('assets/Home.png')),
                    title: Text(
                      'Data Saya',
                      style: TextStyle(
                        color: widget.routeName == RoutesName.MY_DATA ||
                                widget.routeName == '/patient/me'
                            ? AppColors.selected
                            : AppColors.list,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.MY_DATA);
                    },
                  ),
                ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
