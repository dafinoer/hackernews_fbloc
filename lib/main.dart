import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/job/job_bloc.dart';
import 'package:hackernews_flutter/bloc/job/job_state.dart';
import 'package:hackernews_flutter/bloc/navigator/navigator_bloc.dart';
import 'package:hackernews_flutter/bloc/new/new_bloc.dart';
import 'package:hackernews_flutter/bloc/new/new_state.dart';
import 'package:hackernews_flutter/bloc/observer/main_observer.dart';
import 'package:hackernews_flutter/bloc/settings/settings_bloc.dart';
import 'package:hackernews_flutter/bloc/settings/settings_state.dart';
import 'package:hackernews_flutter/bloc/top/top_bloc.dart';
import 'package:hackernews_flutter/bloc/top/top_state.dart';
import 'package:hackernews_flutter/screen/home.dart';
import 'package:hackernews_flutter/utils/logger_config.dart';
import 'package:hackernews_flutter/utils/routes.dart';
import 'package:hackernews_flutter/utils/values.dart';

main() {
  LoggerConfig.instance();
  Bloc.observer = MainBlocObserver();
  runApp(HackerNewsFlutter());
}

class HackerNewsFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(SettingsMenu()),
      child: BlocBuilder<SettingsBloc, SettingsMenu>(
        builder: (_, state){
        return MaterialApp(
          title: 'HackerNews Flutter',
          theme: state is SettingsMenu && state.isDarkTheme ? ThemeData.dark() : ThemeData(primaryColor: primaryColor),
          routes: RouteHackerNews.routing(context),
          home: MultiBlocProvider(providers: [
            BlocProvider(create: (_) => NavigatorBloc(0),),
            BlocProvider(create: (_) => TopBloc(TopLoading())),
            BlocProvider(create: (_) => NewBloc(NewLoading()),),
            BlocProvider(create: (_) => JobBloc(JobsLoading()),),
          ], child: Home()));
      }),
    );
  }
}
