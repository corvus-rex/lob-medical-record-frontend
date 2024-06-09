import 'package:lob_frontend/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lob_frontend/components/header.dart';
import 'package:lob_frontend/constants/placeholder_data.dart';
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

class MyDataPage extends StatefulWidget {
  const MyDataPage({super.key});

  @override
  _MyDataPageState createState() => _MyDataPageState();
}

class _MyDataPageState extends State<MyDataPage> {
  final _storage = const FlutterSecureStorage();
  String? _accessToken; 
  bool _loadFinished = false;
  List<dynamic> items = [];
  Map<String, double> _progressingVids = {};

  @override
  void initState() {
    super.initState();
    DateTime lastEdited;
    String rawLastEdited;
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
        ],
      ),)
    );
  }
}
