import 'package:bloc/bloc.dart';
import 'package:hackernews_flutter/bloc/comment/comment_event.dart';
import 'package:hackernews_flutter/bloc/comment/comment_state.dart';
import 'package:hackernews_flutter/model/comment.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hackernews_flutter/repository/comment_repository.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc(CommentState initialState) : super(initialState);

  CommentRepository _commentRepository = CommentRepository();

  @override
  Stream<Transition<CommentEvent, CommentState>> transformEvents(Stream<CommentEvent> events, transitionFn) {
    return super.transformEvents(events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is CommentListOfId) {
      if (state is CommentLoading) {
        final listId = event.listOfKids.map((e) {
          _commentRepository
              .setUrl(Endpoint.item.replaceAll('{id}', e.toString()));
          return _commentRepository.fetchComment();
        });
        final listOfComment = await Future.wait(listId);

        print(listOfComment);

        yield CommentLoaded(listOfComment: listOfComment);
      }
    }
  }

  Future<List<Comment>> recursiveIdLoad(List<int> listOfId) async {
    final listId = listOfId.map((e) {
      _commentRepository.setUrl(Endpoint.item.replaceAll('{id}', e.toString()));
      return _commentRepository.fetchComment();
    });
    final listOfComment = await Future.wait(listId);

    final List<Comment> temp = [];

    listOfComment.forEach((element) async {
      if (element.kids.isNotEmpty) {
        var test = await recursiveIdLoad(listOfId);
        temp.addAll(test);
      }
    });

    return listOfComment + temp;
  }
}
