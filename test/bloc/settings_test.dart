import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackernews_flutter/bloc/settings/settings_bloc.dart';
import 'package:hackernews_flutter/bloc/settings/settings_event.dart';
import 'package:hackernews_flutter/bloc/settings/settings_state.dart';

main() {
  group('settings', () {
    SettingsBloc settingsBloc;

    setUp(() {
      settingsBloc = SettingsBloc(SettingsMenu());
    });

    blocTest(
      'emit dark mode',
      build: () => settingsBloc,
      act: (bloc) => bloc.add(DarkTheme(isDarkTheme: true)),
      expect: [isA<SettingsMenu>()],
    );
    
    blocTest(
      'emit light mode', 
      build: () => settingsBloc,
      act: (bloc) => bloc.add(DarkTheme(isDarkTheme: false)),
      expect: [isA<SettingsMenu>()]
      );
  });
}
