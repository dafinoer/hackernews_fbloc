


abstract class SettingsEvent {}

class DarkTheme extends SettingsEvent{ 
  final bool isDarkTheme;

  DarkTheme({this.isDarkTheme});
}