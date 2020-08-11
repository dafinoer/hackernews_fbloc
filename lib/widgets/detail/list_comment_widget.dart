import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hackernews_flutter/bloc/comment/comment_bloc.dart';
import 'package:hackernews_flutter/bloc/comment/comment_state.dart';
import 'package:hackernews_flutter/utils/values.dart';
import 'package:url_launcher/url_launcher.dart';

class ListCommentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = BlocProvider.of<CommentBloc>(context);
    final theme = Theme.of(context);

    return BlocBuilder<CommentBloc, CommentState>(
        cubit: provider,
        builder: (_, state) {
          if (state is CommentLoading) {
            return Padding(
              padding: EdgeInsets.only(top: space_4x),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is CommentLoaded && state.listOfComment.isNotEmpty) {
            return ListView.separated(
                separatorBuilder: (_, index) => Divider(),
                itemCount: state.listOfComment.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: space_4x),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Html(
                            data: state.listOfComment[index].text,
                            onLinkTap: (link) async {
                              var url = link.toString();
                              final isCanLaunch = await canLaunch(url);
                              if (isCanLaunch) await launch(url); 
                              else throw 'Could not launch $url';
                            },
                          ),
                        ],
                      ));
                });
          }

          if (state is CommentLoaded && state.listOfComment.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: space_4x),
              child: Center(
                  child: Text(
                'No Comment',
                style: theme.textTheme.subtitle2,
              )),
            );
          }
        });
  }
}
