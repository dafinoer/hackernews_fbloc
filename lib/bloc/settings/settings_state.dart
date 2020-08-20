import 'package:hackernews_flutter/bloc/settings/settings_event.dart';

abstract class SettingsState {}

class SettingsMenu extends SettingsState {
  final bool isDarkTheme;
  final TypeList typeList;

  SettingsMenu({this.isDarkTheme = false, this.typeList = TypeList.Normal});

  SettingsMenu copyWith({bool isDark, TypeList typeList}) {
    return SettingsMenu(
        isDarkTheme: isDark ?? this.isDarkTheme,
        typeList: typeList ?? this.typeList);
  }
}
