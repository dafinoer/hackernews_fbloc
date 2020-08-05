

class Endpoint {

  static const String _baseurl = 'https://hacker-news.firebaseio.com';

  static const String top_stories_ids = _baseurl + '/v0/topstories.json?print=pretty';


  ///https://hacker-news.firebaseio.com/v0/item/8863.json?print=pretty
  static const String item = _baseurl + '/v0/item/{id}.json'; 
}