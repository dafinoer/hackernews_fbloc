import 'package:bloc/bloc.dart';
import 'package:hackernews_flutter/bloc/comment/comment_event.dart';
import 'package:hackernews_flutter/bloc/comment/comment_state.dart';
import 'package:hackernews_flutter/model/comment.dart';
import 'package:hackernews_flutter/utils/function_helper.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hackernews_flutter/repository/comment_repository.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc(CommentState initialState) : super(initialState);

  CommentRepository _commentRepository = CommentRepository();

  var log = Logger();

  @override
  Stream<Transition<CommentEvent, CommentState>> transformEvents(
      Stream<CommentEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    final currentState = state;
    try {
      if (event is CommentListOfId) {
        if (state is CommentLoading) {
          var itemComment = FuntionHelper.convertToEndpoint(event.listOfKids);
          // final allComment = await recursiveTest(itemComment, item);
          if (itemComment.length > 0) {
            var dataItem = List<Comment>();
            if (itemComment.length > 10) {
              dataItem = await _commentRepository
                  .quequeAsync(itemComment.take(10).toList());
            } else {
              dataItem = await _commentRepository.quequeAsync(itemComment);
            }
            yield CommentLoaded(listOfComment: dataItem);
          } else {
            yield CommentLoaded(listOfComment: []);
          }
        }
      }

      // if (event is CommentItem) {
      //   if (currentState is CommentLoaded) {
      //     final listUrl = FuntionHelper.convertToEndpoint(event.comment.kids);
      //     final items = await _commentRepository.quequeAsync(listUrl);
      //     final indexParent = currentState.listOfComment.indexOf(event.comment);

      //     yield currentState.copywith();
      //   }
      // }
    } catch (e) {
      print(e);
      yield CommentError(e.toString());
    }
  }

  Future<List<Comment>> recursiveTest(
      List<String> ids, List<Comment> params) async {
    for (var value in ids) {
      final item = await _commentRepository.fetchComment(value);
      if (item.kids.isNotEmpty) {
        params.add(item);
        await recursiveTest(FuntionHelper.convertToEndpoint(item.kids), params);
      } else {
        params.add(item);
      }
    }
    return params;
  }

  Future<Comment> newComment(int id, int indexId, int lengthKids) async {
    if (indexId < lengthKids) {
      final resultItem = await _commentRepository
          .fetchComment(Endpoint.item.replaceAll('{id}', id.toString()));
      return newComment(
          resultItem.kids[indexId], indexId + 1, resultItem.kids.length);
    }
    return null;
  }
}
