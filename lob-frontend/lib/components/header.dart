import 'package:lob_frontend/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lob_frontend/constants/route_names.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final GlobalKey _key = GlobalKey();
  int? _userType;
  final _storage = const FlutterSecureStorage();
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
      _userType = _userData['user_type'];
    });
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(
          width: MediaQuery.of(context).size.width*0.175,
          child: const SizedBox(width: 0)
        ),
        const Spacer(),
        SizedBox(
          width: 287.5,
          child: Row(
            children: [
              Text("Dashboard Type: " + (_userType == 1 ? "Admin" : _userType == 2 ? "Doctor" : _userType == 3 ? "Staff" : _userType == 4 ? "Patient" : "Unknown"))
            ],
          )
        ),
        SizedBox(
          width: 287.5,
          child: Row(
            children: [
                Container(
                  child: Image.asset('assets/lob_simplified.png'),
                )
                // child: TextButton(
                //   onPressed: () => {
                //     Navigator.pushNamed(context, RoutesName.NEW_VID)
                //   },
                //   child: const Expanded(child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Text("New Video    ", style: TextStyle(color:Colors.white, fontSize: 18),),
                //       ImageIcon(color: Colors.white, AssetImage('assets/Add.png'))
                //     ],
                //   )),
                // ),
            ],
          )
        ),
      ],
      );
        
  }

}