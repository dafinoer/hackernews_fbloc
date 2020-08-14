import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackernews_flutter/bloc/navigator/navigator_bloc.dart';
import 'package:hackernews_flutter/bloc/navigator/navigator_event.dart';

class MockCounterBloc extends MockBloc<int> implements NavigatorBloc {}

void main() {
  group('NavigatorBloc', () {
    NavigatorBloc navBloc;

    setUp(() {
      navBloc = NavigatorBloc(0);
    });

    tearDown(() {
      navBloc.add(NavigationType.TOP);
    });

    blocTest('emit NavigationType.Top for navigation top menu',
        build: () => navBloc,
        act: (bloc) => bloc.add(NavigationType.TOP),
        expect: [0]);

    blocTest('emit NavigationType.New new menu',
        build: () => navBloc,
        act: (bloc) => bloc.add(NavigationType.NEW),
        expect: [1]);
    blocTest('emit NavigationType.Jobs job menu',
        build: () => navBloc,
        act: (bloc) => bloc.add(NavigationType.JOBS),
        expect: [2]);
    blocTest('emit NavigationType.Settings setting menu',
        build: () => navBloc,
        act: (bloc) => bloc.add(NavigationType.SETTINGS),
        expect: [3]);
  });
}
