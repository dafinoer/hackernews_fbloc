import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/navigator/navigator_bloc.dart';
import 'package:hackernews_flutter/screen/jobs/job_page.dart';
import 'package:hackernews_flutter/screen/new/new_page.dart';
import 'package:hackernews_flutter/screen/settings/settings_page.dart';
import 'package:hackernews_flutter/screen/top/top_page.dart';
import 'package:hackernews_flutter/widgets/bottom_nav_bar.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigatorBloc, int>(builder: (_, state) {
      return Scaffold(
        body: _viewWidget[state],
        bottomNavigationBar: BottomNavBar(),
      );
    });
  }

  UnmodifiableListView<Widget> get _viewWidget {
    return UnmodifiableListView([TopPage(), NewPage(), JobPage(), SettingsPage()]);
  }
}
