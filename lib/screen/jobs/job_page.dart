


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hackernews_flutter/utils/strings.dart';

class JobPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JobPage();
  }
}

class _JobPage extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.job),
      ),
      body: Center(child: Text(Strings.job),),
    );
  }
}