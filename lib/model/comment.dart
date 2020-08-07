


import 'package:hackernews_flutter/model/item.dart';
import 'package:hackernews_flutter/utils/strings.dart';

class Comment extends Item{
  final String text;
  final List<int> kids;
  final int parent;
  Comment({int id, int time, String type, String by, this.text, this.kids, this.parent}) : super(id, time, type, by);

  @override
  List<Object> get props => super.props..addAll([text, kids, parent]);

  factory Comment.fromJson(Map jsonData){
    return Comment(
      by: jsonData[Strings.param_by] ?? '',
      id: jsonData[Strings.param_id] ?? 0,
      kids: List.from(jsonData[Strings.param_kids] ?? []),
      parent: jsonData[Strings.param_parent] ?? 0,
      text: jsonData[Strings.param_text] ?? '',
      time: jsonData[Strings.param_time] ?? 0,
      type: jsonData[Strings.param_type] ?? '',
    );
  }
}