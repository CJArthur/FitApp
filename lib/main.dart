import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.dark, barBackgroundColor: Color.fromARGB(0, 208, 11, 11)),
      home: MyCupertinoPage(),
    );
  }
}

class MyCupertinoPage extends StatelessWidget {
  const MyCupertinoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        
        middle: Text('Screen in IOS style'),
      ),
      child: Center(
        child: CupertinoButton.filled(
          onPressed: null,
          child: Text('My button'),
        ),
      ),
    );
  }
}
