import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/settings/settings_bloc.dart';
import 'package:hackernews_flutter/bloc/settings/settings_event.dart';
import 'package:hackernews_flutter/bloc/settings/settings_state.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  
  @override
  Widget build(BuildContext context) {
    final provider = BlocProvider.of<SettingsBloc>(context);
    
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SwitchListTile(
              title: const Text(
                'Dark Theme',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: BlocProvider.of<SettingsBloc>(context).state.isDarkTheme,
              onChanged: (bool value) {
                context.bloc<SettingsBloc>().add(DarkTheme(isDarkTheme: value));
              },
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
