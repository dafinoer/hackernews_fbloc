

class Endpoint {

  static const String _baseurl = 'https://hacker-news.firebaseio.com';
  static const String BASE_URL = _baseurl;

  static const String top_stories_ids = _baseurl + '/v0/topstories.json?print=pretty';
  static const String new_stories_ids = _baseurl + '/v0/newstories.json?print=pretty';
  static const String job_stories_id = _baseurl + '/v0/jobstories.json?print=pretty';

  static const String top_ids = '/v0/topstories.json?print=pretty';
  static const String ITEM = '/v0/item/{id}.json?print=pretty';

  ///https://hacker-news.firebaseio.com/v0/item/8863.json?print=pretty
  static const String item = _baseurl + '/v0/item/{id}.json'; 
}