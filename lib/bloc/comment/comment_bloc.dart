import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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

  List<Comment> listComment = [];

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is CommentListOfId) {
      var temp = [];
      if (state is CommentLoading) {
        print(event.listOfKids);
        var itemComment = listOfFuture(event.listOfKids);
        var item = List<Comment>();
        final allComment = await recursiveTest(itemComment, item);

        // itemComment.forEach((v) async {
        //   final item = await _commentRepository.fetchComment(v);
        //   if (item.kids.isNotEmpty) {}
        // });

        // /var comments = await Future.wait(itemComment);

        // comments.forEach((element) async {
        //   if (element.kids.isNotEmpty) {
        //     var listId = listOfFuture(element.kids);
        //     var subCommentItem = await Future.wait(listId);
        //     temp.add({'parent': element, 'sub': subCommentItem});
        //   }
        // });
        yield CommentLoaded(listOfComment: allComment);
      }
    }
  }


  // Future<List<Comment>> testFlight(List<String> idparams) async {
  //   List<Comment> listCollection = [];

  //   for (var x in idparams) {
  //     final item = await _commentRepository.fetchComment(x);
  //     if(item.kids.isNotEmpty){
  //       var collection = await recursiveTest(listOfFuture(item.kids), []);
  //     }
  //   }

  //   return listCollection;
  // }

  Future<List<Comment>> recursiveTest(List<String> ids, List<Comment> params) async {
    for (var value in ids) {
      final item = await _commentRepository.fetchComment(value);
      if (item.kids.isNotEmpty) {
        params.add(item);
        await recursiveTest(listOfFuture(item.kids), params);
      } else {
        params.add(item);
      }
    }
    return params;
  }

  Stream<CommentState> fetchComment() async* {}

  List<String> listOfFuture(List<int> listId) {
    return listId.map((e) {
      final url = Endpoint.item.replaceAll('{id}', e.toString());
      return url;
    }).toList();
  }

  String endpointReplace(String id) {
    return Endpoint.item.replaceAll('{id}', id.toString());
  }

  // Future<List<Comment>> infiniteListOfComment(
  //     Comment comment, List<Comment> listcom) async {
  //   if (comment.kids.isNotEmpty) {
  //     final testIdList = _commentRepository.listOfFuture(comment.kids);
  //     final items = await Future.wait(testIdList);

  //     return infiniteListOfComment(comment, listcom);
  //   } else {
  //     return listcom;
  //   }
  // }

  Future<Comment> newComment(int id, int indexId, int lengthKids) async {
    if (indexId < lengthKids) {
      final resultItem = await _commentRepository
          .fetchComment(Endpoint.item.replaceAll('{id}', id.toString()));
      return newComment(
          resultItem.kids[indexId], indexId + 1, resultItem.kids.length);
    }
    return null;
  }

  // List<Future<Comment>> listOfFuture(List<int> listId) => listId.map((e) {
  //       final url = Endpoint.item.replaceAll('{id}', e.toString());
  //       _commentRepository.setUrl(url);
  //       return _commentRepository.fetchComment();
  //     }).toList();
}
