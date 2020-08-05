


import 'package:equatable/equatable.dart';

class Item extends Equatable{

  final int id;

  final int time;

  final String type;

  final String by;

  Item(this.id, this.time, this.type, this.by);

  @override
  List<Object> get props => [id, time, type, by];
}


