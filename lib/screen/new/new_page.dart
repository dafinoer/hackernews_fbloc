import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/new/new_bloc.dart';
import 'package:hackernews_flutter/bloc/new/new_events.dart';
import 'package:hackernews_flutter/bloc/new/new_state.dart';
import 'package:hackernews_flutter/utils/strings.dart';
import 'package:hackernews_flutter/utils/values.dart';

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
    context.bloc<NewBloc>().close();
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
            return ListView.builder(
                itemCount: state.isMax
                    ? state.listStory.length
                    : state.listStory.length + 1,
                itemBuilder: (_, index) {

                  if(index == state.listStory.length + 1){
                    return Center(child: CircularProgressIndicator(),);
                  }

                  return Padding(
                      padding: EdgeInsets.symmetric(vertical: space_2x),
                      child: ExpansionTile(
                        title: Text(
                          state.listStory[index].title,
                          style: theme.textTheme.subtitle1,
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: space_4x, vertical: space_2x),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  child: Text(
                                    state.listStory[index].url,
                                    style: TextStyle(color: linkUrlColor),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {},
                                )),
                          )
                        ],
                      ),
                    );
                });
          }
        }));
  }

  void firstEvent() {
    final proivders = BlocProvider.of<NewBloc>(context);

    if (proivders.state is NewLoading) {
      proivders.add(NewStoriesEvent(start: 0, limit: 20));
    }
  }
}
