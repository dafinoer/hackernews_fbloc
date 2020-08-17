import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/settings/settings_event.dart';
import 'package:hackernews_flutter/bloc/settings/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsMenu> {
  SettingsBloc(SettingsState initialState) : super(initialState);

  @override
  Stream<SettingsMenu> mapEventToState(SettingsEvent event) async* {
    switch (event.runtimeType) {
      case DarkTheme:
        yield* darkTheme(event, state);
        break;
      default:
    }
  }

  Stream<SettingsMenu> darkTheme(DarkTheme event, SettingsMenu menu) async* {
    yield menu.copyWith(isDark: event.isDarkTheme);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
