import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackernews_flutter/bloc/top/top_bloc.dart';
import 'package:hackernews_flutter/bloc/top/top_event.dart';
import 'package:hackernews_flutter/bloc/top/top_state.dart';
import 'package:hackernews_flutter/repository/topstories_repository.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';
import 'package:mockito/mockito.dart';

class MockTopBloc extends MockBloc<TopState> implements TopBloc {}

class MockTopRepository extends Mock implements TopStoriesRepository {}

void main() {
  group('top bloc', () {
    TopBloc topBloc;
    TopStoriesRepository repository;

    setUp(() {
      topBloc = MockTopBloc();
      repository = MockTopRepository();
    });

    test('fetch ids service api', () async {
      final originRepository = TopStoriesRepository();
      when(repository.fetchIds(Endpoint.top_stories_ids)).thenAnswer(
          (_) async => repository.fetchIds(Endpoint.top_stories_ids));

      expect(await originRepository.fetchIds(Endpoint.top_stories_ids),
          isA<List<int>>());
    });

    blocTest('emit [TopLoading] waiting loading',
        build: () {
          topBloc = MockTopBloc();
          whenListen(topBloc, Stream.fromIterable([TopLoading()]));
          return topBloc;
        },
        act: (bloc) => bloc.add(TopIdEvent(limit: 0, indexStart: 10)),
        expect: [isA<TopLoading>()]);

    blocTest('emit [TopLoading, TopLoaded] get item',
        build: () {
          whenListen(topBloc, Stream.fromIterable([TopLoading(), TopLoaded()]));
          return topBloc;
        },
        act: (bloc) => bloc.add(TopIdEvent(limit: 0, indexStart: 10)),
        expect: [isA<TopLoading>(), isA<TopLoaded>()]);
  });
}
