


import 'package:flutter/material.dart';
import 'package:hackernews_flutter/utils/function_helper.dart';

class TimePostWidget extends StatelessWidget {
  final int milisecondEpoch;

  TimePostWidget({this.milisecondEpoch});

  @override
  Widget build(BuildContext context) {
    return Text(_dateUpload(milisecondEpoch));
  }

  String _dateUpload(int time) => FuntionHelper.diffWithText(time);
}