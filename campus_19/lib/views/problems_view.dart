import 'package:campus_19/components/filter_dialog.dart';
import 'package:campus_19/components/problem_dialog.dart';
import 'package:campus_19/components/problem_tile.dart';
import 'package:campus_19/controllers/problems_controller.dart';
import 'package:campus_19/repo.dart';
import 'package:campus_19/views/stats_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model.dart';

abstract class ProblemsViewContract {
  void onGetProblemsSuccess(List<Problem> problems);

  void toggleLoaded();

  void showError(error);
}

class ProblemsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProblemsViewState();
}

class _ProblemsViewState extends State<ProblemsView>
    implements ProblemsViewContract {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Filter _filter;
  ProblemsController _controller;
  bool _loaded;
  List<Problem> _problems;

  _ProblemsViewState() {
    _controller = ProblemsController(this, SqliteRepo());
  }

  initState() {
    super.initState();
    _loaded = false;
    _filter = Filter.empty();
    _controller.getProblems(_filter, '');
  }

  @override
  void showError(error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Error: $error'),
    ));
  }

  @override
  void toggleLoaded() {
    setState(() {
      _loaded = !_loaded;
    });
  }

  @override
  void onGetProblemsSuccess(List<Problem> problems) {
    setState(() {
      if (!_loaded) _loaded = true;
      _problems = problems;
    });
  }

  Function onLongPressProblem(int i) => () {
        Problem p = _problems[i];
        setState(() {
          p.sent = !p.sent;
          _problems[i] = p;
          _controller.update(p);
        });
      };

  Function onTapProblem(BuildContext context, int i) {
    return () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProblemDialog(
              problem: _problems[i],
            );
          }).then((p) {
        if (p != null) {
          setState(() {
            _problems[i] = p;
            _controller.update(p);
          });
        }
      });
    };
  }

  Function onTapFilter(BuildContext context) {
    return () {
      showDialog(
          context: context,
          builder: (BuildContext context) => FilterDialog(_filter)).then((f) {
        if (f != null) {
          setState(() {
            _filter = f;
            _controller.getProblems(_filter, '');
          });
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(101.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              elevation: 4.0,
              child: Container(
                height: 20.0,
                color: Colors.blueGrey[400],
              ),
            ),
            Divider(
              height: 1.0,
            ),
            Header(
              onTextChanged: (String s) => _controller.getProblems(_filter, s),
              onTapFilter: onTapFilter(context),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView.separated(
        itemBuilder: (BuildContext ctx, int i) => ProblemTile(
          problem: _problems[i],
          onLongPress: onLongPressProblem(i),
          onTap: onTapProblem(ctx, i),
        ),
        separatorBuilder: (BuildContext _ctx, int i) => Divider(
          height: 1.0,
        ),
        itemCount: _problems.length,
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Function onTextChanged;
  final Function onTapFilter;

  Header({
    this.onTextChanged,
    this.onTapFilter,
  });

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: Colors.grey[200],
            width: 1.0,
          ),
        ),
        color: Colors.grey[50],
      ),
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Card(
        elevation: 3.0,
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.insert_chart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => StatsView(),
              ));
            },
          ),
          title: TextField(
            onChanged: onTextChanged,
            autocorrect: false,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Search...'),
          ),
          trailing: IconButton(
            icon: FaIcon(FontAwesomeIcons.slidersH, size: 18.0),
            onPressed: onTapFilter,
          ),
//          trailing: PopupMenuButton<SortChoice>(
//            icon: FaIcon(FontAwesomeIcons.slidersH, size: 18.0),
//            initialValue: SortChoice.Alpha,
//            itemBuilder: (BuildContext _ctx) => <PopupMenuEntry<SortChoice>>[
//              PopupMenuItem(
//                value: SortChoice.Alpha,
//                child: ListTile(
//                  leading: Icon(Icons.sort_by_alpha),
//                  title: Text('Alpha'),
//                ),
//              ),
//              PopupMenuItem(
//                value: SortChoice.GradeA,
//                child: ListTile(
//                    leading: Icon(Icons.insert_chart), title: Text('Grade')),
//              ),
//              PopupMenuItem(
//                value: SortChoice.GradeB,
//                child: ListTile(
//                  leading: Icon(Icons.insert_chart),
//                  title: Text('Grade 2'),
//                ),
//              ),
//              PopupMenuItem(
//                value: SortChoice.Quality,
//                child: ListTile(
//                  leading: Icon(Icons.star),
//                  title: Text('Quality'),
//                ),
//              ),
//            ],
//          ),
        ),
      ));
}
