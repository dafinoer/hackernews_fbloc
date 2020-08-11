
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
  Stream<Transition<CommentEvent, CommentState>> transformEvents(
      Stream<CommentEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is CommentListOfId) {
      if (state is CommentLoading) {
        var itemComment = listOfFuture(event.listOfKids);
        var comments = await Future.wait(itemComment);
        var temp = [];

        comments.forEach((element) async {
          if (element.kids.isNotEmpty) {
            var listId = listOfFuture(element.kids);
            var subCommentItem = await Future.wait(listId);
            temp.add({'parent': element, 'sub': subCommentItem});
          }
        });
        yield CommentLoaded(listOfComment: comments);
      }
    }
  }

  Future<List<Comment>> infiniteListOfComment(Comment comment, List<Comment> listcom) async{
    if(comment.kids.isNotEmpty){
      final testIdList = listOfFuture(comment.kids);
      final items = await Future.wait(testIdList);

      return infiniteListOfComment(comment, listcom);
    } else {
      return listcom;
    }
  }

  Future<Comment> newComment(int id, int indexId, int lengthKids) async {
    if (indexId < lengthKids) {
      _commentRepository.setUrl(Endpoint.item.replaceAll('{id}', id.toString()));
      final resultItem = await _commentRepository.fetchComment();
      return newComment(
        resultItem.kids[indexId], 
        indexId + 1, 
        resultItem.kids.length
        );
    }
    return null;
  }

  List<Future<Comment>> listOfFuture(List<int> listId) => listId.map((e) {
        final url = Endpoint.item.replaceAll('{id}', e.toString());
        _commentRepository.setUrl(url);
        return _commentRepository.fetchComment();
      }).toList();
}
