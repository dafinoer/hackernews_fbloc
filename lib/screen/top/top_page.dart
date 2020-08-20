import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/settings/settings_bloc.dart';
import 'package:hackernews_flutter/bloc/settings/settings_event.dart';
import 'package:hackernews_flutter/bloc/top/top_bloc.dart';
import 'package:hackernews_flutter/bloc/top/top_event.dart';
import 'package:hackernews_flutter/bloc/top/top_state.dart';
import 'package:hackernews_flutter/screen/detail/detail_page.dart';
import 'package:hackernews_flutter/utils/detail_arguments.dart';
import 'package:hackernews_flutter/utils/function_helper.dart';
import 'package:hackernews_flutter/utils/strings.dart';
import 'package:hackernews_flutter/utils/values.dart';
import 'package:hackernews_flutter/widgets/detail/text_and_icon_widget.dart';

class TopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TopPage();
  }
}

class _TopPage extends State<TopPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _firstEvent();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    // context.bloc<TopBloc>().close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.top),
        ),
        body: RefreshIndicator(
          color: context.bloc<SettingsBloc>().state.isDarkTheme
              ? theme.accentColor
              : primaryColor,
          onRefresh: () async {
            context.bloc<TopBloc>().add(RefreshPullRequest(0, 20));
            return await Future.delayed(Duration(milliseconds: 500));
          },
          child: BlocConsumer<TopBloc, TopState>(
            listener: (_, state) {
              if (state is TopError) {
                FuntionHelper.showSnackbar(context, 'uppps error');
              }
            },
            builder: (_, state) {
              if (state is TopLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is TopLoaded) {
                return ListView.separated(
                    separatorBuilder: (_, index) => Divider(),
                    controller: _scrollController,
                    itemCount: state.isMax
                        ? state.listStory.length
                        : state.listStory.length + 1,
                    itemBuilder: (_, index) {
                      if (index >= state.listStory.length) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListTile(
                        title: Text(
                          state.listStory[index].title,
                          style: theme.textTheme.subtitle1,
                        ),
                        subtitle: context.bloc<SettingsBloc>().state.typeList ==
                                TypeList.Normal
                            ? Padding(
                                padding: EdgeInsets.only(top: space_2x),
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.favorite_border,
                                          size: space_4x,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: space_1x),
                                          child: Text(
                                            state.listStory[index].score
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: space_3x),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.message, size: space_4x),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: space_1x),
                                            child: Text(
                                              state.listStory[index].kids.length
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : null,
                        onTap: () {
                          Navigator.pushNamed(context, DetailPage.routeName,
                              arguments: DetailArguments(
                                  story: state.listStory[index]));
                        },
                      );
                    });
              }
            },
          ),
        ));
  }

  String _dateUpload(int time) {
    final dates = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    print(dates);
    return FuntionHelper.diffWithText(time);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= 200.0) {
      context.bloc<TopBloc>().add(TopIdEvent());
    }
  }

  void _firstEvent() {
    final providers = BlocProvider.of<TopBloc>(context);
    if (providers.state is TopLoading) {
      context.bloc<TopBloc>().add(TopIdEvent(indexStart: 0, limit: 20));
    }
  }
}
