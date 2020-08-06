import 'package:flutter/material.dart';
import 'package:hackernews_flutter/screen/detail/detail_page.dart';


class RouteHackerNews {

  static Map<String, WidgetBuilder> routing(BuildContext context) {
    final routes = {
      DetailPage.routeName : (context) => DetailPage()
    };
    return routes;
  }
}