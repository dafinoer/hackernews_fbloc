abstract class SettingsState {}

class SettingsMenu extends SettingsState {
  final bool isDarkTheme;

  SettingsMenu({this.isDarkTheme = false});

  SettingsMenu copyWith({bool isDark}) {
    return SettingsMenu(isDarkTheme: isDark ?? this.isDarkTheme);
  }
}
