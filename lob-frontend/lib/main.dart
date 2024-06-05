import 'package:flutter/material.dart';
import 'package:lob_frontend/views/default.dart';
import 'package:lob_frontend/constants/route_names.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => DefaultPage(child: child!),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RoutesName.HOME,
    );
  }
}