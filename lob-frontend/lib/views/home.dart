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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        _fetchGeneratedVideos().then((res) {
          var media_units = res[0];
          var isAuth = res[1];
          setState(() => {
            if (isAuth != false) {
              if (media_units != null) {
                for (var unit in media_units) {
                  if (unit['media_unit_last_edited'] != null) {
                    rawLastEdited = unit['media_unit_last_edited']
                  } else if (unit['video_last_edited'] != null) {
                    rawLastEdited = unit['video_last_edited']
                  } else if (unit['audio_last_edited'] != null) {
                    rawLastEdited = unit['audio_last_edited']
                  } else {
                    rawLastEdited = '2023-11-11T00:00:00.140761+07:00'
                  },
                  lastEdited = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ").parse(rawLastEdited),
                  unit['subheader'] = formatTimeAgo(lastEdited)
                },
                items = media_units.sublist(0, min<int>(4, media_units.length)),
                _checkVRTProgress(),
                _loadFinished = true
              } else {
                items = [],
                _loadFinished = true
              },
            } else {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamed(RoutesName.LOGIN);
              })
            }
          });
        }).catchError((error) => {
          print("Error: $error")
        })
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

  Future<List> _fetchGeneratedVideos() async{
    final response = await http.get(
      Uri.parse(ApiEndpoints.fetchGenVid),
      headers: {'X-API-Key': _accessToken!, 'ngrok-skip-browser-warning': "69420",},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return [data['media_units'], true];
    } else if (response.statusCode == 401) {
      print("Error: ${response.statusCode} - ${response.body}");
      return [null, false];
    }
    else {
      print("Error: ${response.statusCode} - ${response.body}");
      return [null, true];
    }
  }
  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'over $years ${years == 1 ? 'year' : 'years'} ago';
    }
  }


  void _showVideoModal(BuildContext context, String videoID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200, // Adjust the height of the modal as needed
          child: AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                VideoPlayerWidget(videoUrl: '${ApiEndpoints.playbackGenerated}{$videoID}&token=$_accessToken'), // Your video player widget goes here
              ],
            ),
          )
        );
      },
    );
  }
  
  void _checkVRTProgress() async {

    _fetchVRTProgress();
    // Schedule the function to run every 4 seconds
    Timer.periodic(Duration(seconds: 5), (timer) async {
      _fetchVRTProgress();
    });
  }

  void _fetchVRTProgress() async {
    final response = await http.get(
        Uri.parse(ApiEndpoints.checkVRTProgress),
        headers: {'X-API-Key': _accessToken!, 'ngrok-skip-browser-warning': "69420",},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _progressingVids = {};
        });
        for (var media in data['video_list']) {
          setState(() {
            _progressingVids[media['current_video']] = double.parse(media['progress']);
          });
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
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
          ),
          Expanded(
            child: _loadFinished == true ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                const SizedBox(height: 10,),
                const Text(
                  "  Recent",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.header
                  )
                ),
                const SizedBox(height: 15,),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: (items.length / (
                    MediaQuery.of(context).size.width > 1470 
                    ? 4 : MediaQuery.of(context).size.width > 1000 
                    ? 3 : 2)).ceil(),
                  itemBuilder: (context, index) {
                    final startIndex = index * (
                    MediaQuery.of(context).size.width > 1470 
                    ? 4 : MediaQuery.of(context).size.width > 1190 
                    ? 3 : 2);
                    final endIndex = (startIndex + (
                    MediaQuery.of(context).size.width > 1470 
                    ? 4 : MediaQuery.of(context).size.width > 1190 
                    ? 3 : 2)) > items.length ? items.length : (startIndex + (
                    MediaQuery.of(context).size.width > 1470 
                    ? 4 : MediaQuery.of(context).size.width > 1190 
                    ? 3 : 2));
                    final rowItems = items.getRange(startIndex, endIndex).toList();
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: rowItems.map((item) {
                        return Container(
                          margin: const EdgeInsets.all(30),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0), 
                                border: Border.all(
                                  color: AppColors.list, 
                                  width: 1, 
                                ),
                              ),
                              child: InkWell(
                                
                                onTap: () {
                                  ((_progressingVids[item['id']] ?? 100) == 100) ? _showVideoModal(context, item['id']): ();
                                },
                                child: Stack(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0), 
                                    child: Container(
                                      width: 220,
                                      child: Image.network(
                                        item['thumbnail'] != null 
                                        ? ApiEndpoints.static+item['thumbnail'] 
                                        : '${ApiEndpoints.static}avatar_img/Person_A.png', // Replace with the actual URL of your image
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                    : null,
                                              ),
                                            );
                                          }
                                        },
                                        headers: const {'ngrok-skip-browser-warning': '69420'},
                                      )
                                    ),
                                  ),
                                  Positioned(
                                    top: 192,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(color: AppColors.list),
                                      child: Text(
                                        item['audio_duration'] != null 
                                        ? Duration(seconds: item['audio_duration']).toString().split('.').first.substring(2)
                                        : 'None',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ),
                                  ((_progressingVids[item['id']] ?? 100) == 100) ? Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Icon(
                                        Icons.play_arrow,
                                        size: 75,
                                        color: Colors.white.withOpacity(0.8), 
                                      ),
                                    ),
                                  ) : const Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: CircularProgressIndicator(color: AppColors.selected)
                                    ),
                                  ),
                                ])
                            
                              )
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: 220,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start, 
                                crossAxisAlignment: CrossAxisAlignment.start, 
                                children: [
                                Text(
                                  item['caption']?? 'None',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.subheader
                                  ),
                                ),
                                ((_progressingVids[item['id']] ?? 100) == 100) ? Text(
                                  item['subheader'],
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.description
                                  ),
                                ) : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 198,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0), // Set your desired border radius here
                                        child: LinearProgressIndicator(
                                          value: (_progressingVids[item['id']] ?? 0)/100,
                                          backgroundColor: AppColors.progressBG,
                                          valueColor: AlwaysStoppedAnimation(AppColors.selected),
                                          minHeight: 11,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 22,
                                      child: Text(
                                        "${(_progressingVids[item['id']] ?? 0).toStringAsFixed(0)} %",
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.list
                                        ),
                                      )
                                    )
                                  ],
                                )
                              ],)
                            ),
                          ])
                        );
                      }).toList(),
                    );
                  },
                )
              ]),
          ) : Align(
            alignment: Alignment.center,
            child: Container(
              width: 100,
              height: 100,
              child: const CircularProgressIndicator(color: AppColors.selected),
            ),
          )
          )
        ],
      ),)
    );
  }
}
