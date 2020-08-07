import 'package:flutter/material.dart';
import 'package:hackernews_flutter/utils/format_helper.dart';

class FuntionHelper {
  static void showSnackbar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  static int diffInDay(int time) {
    final double diff =
        (DateTime.now().millisecondsSinceEpoch - time) / 86400000;

    return diff.round();
  }

  static int diffInHour(int time) {
    final double diff = (DateTime.now().millisecondsSinceEpoch - time) / 3600000;
    return diff.round();
  }

  static int diffInMinutes(int time) {
    final double diff = (DateTime.now().millisecondsSinceEpoch - time) / 60000;
    return diff.round();
  }
  static String diffWithText(int time) {
    int dayUpload = FuntionHelper.diffInMinutes(time * 1000);

    if (dayUpload < 60) {
      var diffInMinutesAgo = '${dayUpload} minutes ago';
      return diffInMinutesAgo;
    } else if (dayUpload >= 60 && dayUpload < 1440) {
      int diffinHour = FuntionHelper.diffInHour(time * 1000);
      final diffInHourToString = '${diffinHour} hour ago';
      return diffInHourToString;
    } else if (dayUpload >= 1440 && dayUpload <= 10080) {
      int diffInDay = FuntionHelper.diffInDay(time * 1000);
      final diffIndayToString = '${diffInDay} days ago';
      return diffIndayToString;
    } else {
      var dateString = FormatHelper.simpelFormat(
          DateTime.fromMillisecondsSinceEpoch(time * 1000));
      return dateString;
    }
  }
}
