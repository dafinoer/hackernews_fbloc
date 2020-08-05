import 'package:equatable/equatable.dart';
import 'package:hackernews_flutter/model/item.dart';
import 'package:hackernews_flutter/utils/strings.dart';

class Story extends Item with EquatableMixin {
  final int descendants;

  final String title;

  final String url;

  final int score;

  Story({
    int id,
    int time,
    String type,
    String by,
    this.descendants,
    this.title,
    this.url,
    this.score,
  }) : super(id, time, type, by);

  @override
  List<Object> get props =>
      super.props..addAll([descendants, title, url, score]);

  factory Story.fromJson(Map jsonData){
    return Story(
      id: jsonData[Strings.param_id] ?? 0,
      by: jsonData[Strings.param_by] ?? 0,
      descendants: jsonData[Strings.param_descendants] ?? 0,
      score: jsonData[Strings.param_score] ?? 0,
      time: jsonData[Strings.param_time] ?? 0,
      title: jsonData[Strings.param_title] ?? '',
      type: jsonData[Strings.param_type] ?? '',
    );
  }
}
