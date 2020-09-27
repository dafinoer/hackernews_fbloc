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
    final theme = Theme.of(context);

    return BlocBuilder<CommentBloc, CommentState>(
        cubit: BlocProvider.of<CommentBloc>(context),
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

                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(color: Colors.deepOrange[100]))),
                    child: ExpansionTile(
                      children: [ListTile()],
                      title: Container(
                        // padding:
                        //     EdgeInsets.only(left: 8.0 * typeComment.toDouble()),
                        child: Html(
                          data: state.listOfComment[index].text,
                          onLinkTap: _onTapUrl,
                        ),
                      ),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      subtitle: FlatButton(
                          onPressed: () {},
                          child: state.listOfComment[index] != null &&
                                  state.listOfComment[index].kids.isNotEmpty
                              ? Text(state.listOfComment[index].kids.length
                                      .toString() +
                                  ' Comments')
                              : const SizedBox()),
                    ),
                  );
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

          if (state is CommentError) {
            return Padding(
              padding: EdgeInsets.only(top: space_4x),
              child: Center(
                  child: Text(
                'upps something wrong',
                style: theme.textTheme.subtitle2,
              )),
            );
          }
          return const SizedBox();
        });
  }

    void _onTapUrl(String link) async {
      var url = link.toString();
      if (await canLaunch(url)) await launch(url);
      else throw 'Could not launch $url';
    }
}
