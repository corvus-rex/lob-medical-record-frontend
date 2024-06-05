import 'package:flutter/material.dart';
import 'package:lob_frontend/views/home.dart';
import 'package:lob_frontend/views/login.dart';
import 'package:lob_frontend/components/drawer.dart';

class RoutesName {
  static const String LOGIN = '/auth';
  static const String HOME = '/home';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.LOGIN:
        return _GeneratePageRoute(
            widget: Login(), routeName: settings.name!);
      case RoutesName.HOME:
        return _GeneratePageRoute(
            widget: HomePage(), routeName: settings.name!);
      default:
        return _GeneratePageRoute(
            widget: HomePage(), routeName: settings.name!);
    }
  }
}

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget widget;
  final String routeName;
  _GeneratePageRoute({required this.widget, required this.routeName})
      : super(
            settings: RouteSettings(name: routeName),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Scaffold(
                body: Row(
                  children: [
                    routeName != RoutesName.LOGIN
                      ? MyDrawer(routeName: routeName) 
                      : const SizedBox(width:0),
                    widget
                  ],
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return SlideTransition(
                textDirection: TextDirection.rtl,
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            }
        );
}