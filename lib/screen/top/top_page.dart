import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/top/top_bloc.dart';
import 'package:hackernews_flutter/bloc/top/top_event.dart';
import 'package:hackernews_flutter/bloc/top/top_state.dart';
import 'package:hackernews_flutter/screen/detail/detail_page.dart';
import 'package:hackernews_flutter/utils/detail_arguments.dart';
import 'package:hackernews_flutter/utils/function_helper.dart';
import 'package:hackernews_flutter/utils/strings.dart';
import 'package:hackernews_flutter/utils/values.dart';

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
    context.bloc<TopBloc>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.top),
        ),
        body: BlocConsumer<TopBloc, TopState>(
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
              return ListView.builder(
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
                      onTap: () {
                        Navigator.pushNamed(context, DetailPage.routeName,
                            arguments:
                                DetailArguments(story: state.listStory[index]));
                      },
                    );
                    // return Padding(
                    //   padding: EdgeInsets.symmetric(vertical: space_2x),
                    //   child: ExpansionTile(
                    //     title: Text(
                    //       state.listStory[index].title,
                    //       style: theme.textTheme.subtitle1,
                    //     ),
                    //     children: <Widget>[
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: space_4x, vertical: space_2x),
                    //         child: Align(
                    //             alignment: Alignment.topLeft,
                    //             child: GestureDetector(
                    //               child: Text(
                    //                 state.listStory[index].url,
                    //                 style: TextStyle(color: linkUrlColor),
                    //                 maxLines: 2,
                    //                 overflow: TextOverflow.ellipsis,
                    //               ),
                    //               onTap: () {
                    //                 Navigator.pushNamed(
                    //                     context, DetailPage.routeName,
                    //                     arguments: DetailArguments(
                    //                         story: state.listStory[index]));
                    //               },
                    //             )),
                    //       )
                    //     ],
                    //   ),
                    // );
                  });
            }
          },
        ));
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
