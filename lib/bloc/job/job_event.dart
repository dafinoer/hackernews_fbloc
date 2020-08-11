
abstract class JobEvent {

}

class EventIndexStart extends JobEvent{
  final int start;

  final int limit;

  EventIndexStart({this.start, this.limit});
}