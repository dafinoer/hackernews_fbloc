


import 'package:flutter/material.dart';
import 'package:hackernews_flutter/utils/strings.dart';

class NewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewPageState();
  }
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.top),
      ),
      body: Center(child: Text('home'),),
    );
  }
}