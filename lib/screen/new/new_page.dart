import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/new/new_bloc.dart';
import 'package:hackernews_flutter/bloc/new/new_events.dart';
import 'package:hackernews_flutter/bloc/new/new_state.dart';
import 'package:hackernews_flutter/bloc/settings/settings_bloc.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/screen/detail/detail_page.dart';
import 'package:hackernews_flutter/utils/detail_arguments.dart';
import 'package:hackernews_flutter/utils/function_helper.dart';
import 'package:hackernews_flutter/utils/strings.dart';
import 'package:hackernews_flutter/utils/values.dart';
import 'package:hackernews_flutter/widgets/time_post_widget.dart';

class NewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewPageState();
  }
}

class _NewPageState extends State<NewPage> {
  @override
  void initState() {
    firstEvent();
    super.initState();
  }

  @override
  void dispose() {
    // final proivders = BlocProvider.of<NewBloc>(context);
    // proivders.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.latests),
        ),
        body: BlocBuilder<NewBloc, NewState>(builder: (_, state) {
          if (state is NewLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NewError) {
            return Center(
              child: Text(state.txt),
            );
          }

          if (state is NewLoaded) {
            return ListView.separated(
              separatorBuilder: (_, index) => Divider(),
                itemCount: state.isMax
                    ? state.listStory.length
                    : state.listStory.length + 1,
                itemBuilder: (_, index) {
                  if (index == state.listStory.length + 1) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListTile(
                    title: Text(state.listStory[index].title),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          state.listStory[index].by,
                          style: TextStyle(
                              color: BlocProvider.of<SettingsBloc>(context)
                                        .state
                                        .isDarkTheme
                                    ? theme.primaryColorLight
                                    : theme.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: space_3x),
                          child: TimePostWidget(
                            milisecondEpoch: state.listStory[index].time,
                          ),
                        )
                      ],
                    ),
                    onTap: () => ontapAction(state.listStory[index]),
                  );
                });
          }
        }));
  }

  void ontapAction(Story story) {
    Navigator.pushNamed(context, DetailPage.routeName,
        arguments: DetailArguments(story: story));
  }

  void firstEvent() {
    final proivders = BlocProvider.of<NewBloc>(context);

    if (proivders.state is NewLoading) {
      proivders.add(NewStoriesEvent(start: 0, limit: 20));
    }
  }
}
