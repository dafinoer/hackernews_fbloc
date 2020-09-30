import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/settings/settings_bloc.dart';
import 'package:hackernews_flutter/bloc/settings/settings_event.dart';
import 'package:hackernews_flutter/bloc/top/bloc.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/screen/detail/detail_page.dart';
import 'package:hackernews_flutter/utils/detail_arguments.dart';
import 'package:hackernews_flutter/utils/function_helper.dart';
import 'package:hackernews_flutter/utils/values.dart';

class ListWidget extends StatelessWidget {
  BuildContext listContext;

  final ScrollController listController;

  ListWidget(this.listController);

  @override
  Widget build(BuildContext context) {
    listContext = context;
    final theme = Theme.of(context);

    return BlocConsumer<TopBloc, TopState>(
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
              controller: listController,
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
                    state.listStory[index]?.title ?? "",
                    style: theme.textTheme.subtitle1,
                  ),
                  subtitle: context.bloc<SettingsBloc>().state.typeList ==
                          TypeList.Normal
                      ? Padding(
                          padding: EdgeInsets.only(top: space_2x),
                          child: Row(
                            children: <Widget>[
                              scoreWidget(state.listStory[index]),
                              totalDescendant(state.listStory[index])
                            ],
                          ),
                        )
                      : null,
                  onTap: () => _onTapAction(state.listStory[index]),
                );
              });
        }

        return const SizedBox();
      },
    );
  }

  void _onTapAction(Story story) {
    Navigator.pushNamed(listContext, DetailPage.routeName,
        arguments: DetailArguments(story: story));
  }

  Widget scoreWidget(Story story) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.favorite_border,
          size: space_4x,
        ),
        Padding(
          padding: const EdgeInsets.only(left: space_1x),
          child: Text(
            story.score.toString(),
            style: Theme.of(listContext).textTheme.subtitle2,
          ),
        )
      ],
    );
  }

  Widget totalDescendant(Story story) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: space_3x),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.message, size: space_4x),
          Padding(
            padding: const EdgeInsets.only(left: space_1x),
            child: Text(
              story.descendants?.toString() ?? '',
              style: Theme.of(listContext).textTheme.subtitle2,
            ),
          )
        ],
      ),
    );
  }
}
