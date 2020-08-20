abstract class SettingsEvent {}

enum TypeList {Normal, Compact}

class DarkTheme extends SettingsEvent{ 
  final bool isDarkTheme;

  DarkTheme({this.isDarkTheme});
}

class ChoiceTypeList extends SettingsEvent {
  final TypeList typeList;

  ChoiceTypeList(this.typeList);
}