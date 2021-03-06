import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/navigator/navigator_event.dart';

class NavigatorBloc extends Bloc<NavigationType, int> {
  NavigatorBloc(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(NavigationType event) async* {
    switch (event) {
      case NavigationType.TOP:
        yield 0;
        break;

      case NavigationType.NEW:
        yield 1;
        break;

      case NavigationType.JOBS:
        yield 2;
        break;

      case NavigationType.SETTINGS:
        yield 3;
        break;
      default:
    }
  }
}
