
class Strings {

  static const String top = 'Top';
  static const String latests = 'New';
  static const String job  = 'Job';
  static const String settings = 'Settings';

  static const String dark_theme = 'Dark Theme';
  static const String view = 'View';
  static const String subtitle_view = 'Layout of items in the lists';
  static const String use_browser_external = 'Use external browser';
  static const String subtitle_use_browser_external = 'Instead of in-app one';


  /**
   * id	The item's unique id.
   * deleted	true if the item is deleted.
   * type	The type of item. One of "job", "story", "comment", "poll", or "pollopt".
   * by	The username of the item's author.
   * time	Creation date of the item, in Unix Time.
   * text	The comment, story or poll text. HTML.
   * dead	true if the item is dead.
   * parent	The comment's parent: either another comment or the relevant story.
   * poll	The pollopt's associated poll.
   * kids	The ids of the item's comments, in ranked display order.
   * url	The URL of the story.
   * score	The story's score, or the votes for a pollopt.
   * title	The title of the story, poll or job. HTML.
   * parts	A list of related pollopts, in display order.
   * descendants	In the case of stories or polls, the total comment count.
   */

  static const String param_id = 'id';
  static const String param_deleted = 'deleted';
  static const String param_type = 'type';
  static const String param_by = 'by';
  static const String param_time = 'time';
  static const String param_text = 'text';
  static const String param_dead = 'dead';
  static const String param_parent = 'parent';
  static const String param_poll = 'poll';
  static const String param_kids = 'kids';
  static const String param_url = 'url';
  static const String param_score = 'score';
  static const String param_title = 'title';
  static const String param_parts = 'parts';
  static const String param_descendants = 'descendants';
  

}