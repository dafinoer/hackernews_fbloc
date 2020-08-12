import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/job/job_bloc.dart';
import 'package:hackernews_flutter/bloc/job/job_event.dart';
import 'package:hackernews_flutter/bloc/job/job_state.dart';
import 'package:hackernews_flutter/bloc/settings/settings_bloc.dart';
import 'package:hackernews_flutter/screen/detail/detail_page.dart';
import 'package:hackernews_flutter/utils/detail_arguments.dart';
import 'package:hackernews_flutter/utils/strings.dart';
import 'package:hackernews_flutter/utils/values.dart';
import 'package:hackernews_flutter/widgets/time_post_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class JobPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JobPage();
  }
}

class _JobPage extends State<JobPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    final provider = BlocProvider.of<JobBloc>(context);
    if (provider.state is JobsLoading) {
      provider.add(EventIndexStart(start: 0, limit: 20));
    }

    _scrollController = ScrollController();
    _scrollController.addListener(_listener);
    super.initState();
  }

  void _listener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= 200.0) {
      context.bloc<JobBloc>().add(EventIndexStart());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.job),
      ),
      body: BlocBuilder<JobBloc, JobState>(builder: (_, state) {
        if (state is JobsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is JobLoaded) {
          return ListView.separated(
              separatorBuilder: (_, index) => Divider(),
              controller: _scrollController,
              itemCount: state.isMax
                  ? state.listOfJobs.length
                  : state.listOfJobs.length + 1,
              itemBuilder: (_, index) {
                if (index >= state.listOfJobs.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListTile(
                  title: Text(state.listOfJobs[index].title),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        state.listOfJobs[index].by,
                        style: TextStyle(
                            color: BlocProvider.of<SettingsBloc>(context)
                                    .state
                                    .isDarkTheme
                                ? theme.primaryColorLight
                                : theme.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: space_3x),
                        child: TimePostWidget(
                          milisecondEpoch: state.listOfJobs[index].time,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    var urlLink = await canLaunch(state.listOfJobs[index].url);

                    if (urlLink) {
                      await launch(state.listOfJobs[index].url);
                    } else {
                      throw 'Could not launch ${state.listOfJobs[index].url}';
                    }
                  },
                );
              });
        } else if (state is JobError) {
          return Center(
            child: Text(state.txt),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
