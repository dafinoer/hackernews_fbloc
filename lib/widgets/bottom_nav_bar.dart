import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hackernews_flutter/bloc/navigator/navigator_bloc.dart';
import 'package:hackernews_flutter/bloc/navigator/navigator_event.dart';
import 'package:hackernews_flutter/utils/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), title: Text(Strings.top)),
        BottomNavigationBarItem(
            icon: Icon(Icons.history), title: Text(Strings.latests)),
        BottomNavigationBarItem(
            icon: Icon(Icons.work), title: Text(Strings.job))
      ],
      currentIndex: context.bloc<NavigatorBloc>().state,
      onTap: (index) {
        if (index == 0) {
          context.bloc<NavigatorBloc>().add(NavigationType.TOP);
        } else if (index == 1) {
          context.bloc<NavigatorBloc>().add(NavigationType.NEW);
        } else if (index == 2) {
          context.bloc<NavigatorBloc>().add(NavigationType.JOBS);
        }
      },
    );
  }
}
