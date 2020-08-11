import 'package:equatable/equatable.dart';
import 'package:hackernews_flutter/model/item.dart';
import 'package:hackernews_flutter/utils/strings.dart';

class Job extends Item with EquatableMixin {
  final int score;

  final String url;

  final String title;

  Job(
      {this.score,
      this.url,
      this.title,
      int id,
      int time,
      String type,
      String by})
      : super(id, time, type, by);

  @override
  List<Object> get props => super.props..addAll([score, url, title]);

  factory Job.fromJson(Map jsonObject) {
    return Job(
      by: jsonObject[Strings.param_by] ?? '',
      id: jsonObject[Strings.param_id] ?? 0,
      score: jsonObject[Strings.param_score] ?? 0,
      time: jsonObject[Strings.param_time] ?? 0,
      title: jsonObject[Strings.param_title] ?? '',
      type: jsonObject[Strings.param_type] ?? '',
      url: jsonObject[Strings.param_url] ?? ''
    );
  }
}
