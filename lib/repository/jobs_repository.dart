

import 'package:hackernews_flutter/api/item_service.dart';
import 'package:hackernews_flutter/model/job.dart';

class JobsRepository {
 String _url;

 ItemService _service;

 JobsRepository() {
   _service = ItemService();
 }

 String get getUrl => this._url;

 void setUrl(String setUrl){
   this._url = setUrl;
 }

 Future<Job> fetchJobs() async {
   try {
     final jsonResponse = await _service.fetchItem(_url);
     return Job.fromJson(jsonResponse);
   } catch (e) {
     throw Exception(e);
   }
 }

}