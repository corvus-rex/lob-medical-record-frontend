import 'package:flutter/material.dart';


class DefaultPage extends StatelessWidget {
  final Widget child;

  const DefaultPage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child
    );
  }
}