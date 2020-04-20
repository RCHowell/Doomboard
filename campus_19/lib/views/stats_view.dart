import 'package:flutter/material.dart';

import '../model.dart';
import '../repo.dart';

class StatsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  bool _loading;
  List<Widget> _gridItems;
  SqliteRepo _repo;

  _StatsViewState() {
    _repo = SqliteRepo();
  }

  @override
  void initState() {
    super.initState();
    _gridItems = List();
    _loading = true;
    _repo.getAll().then(makeTiles);
  }

  void makeTiles(List<Problem> problems) {
    calculateStats(problems).forEach((label, stat) {
      _gridItems.add(StatTile(
        label: label,
        stat: stat,
      ));
      setState(() {
        _loading = false;
      });
    });
  }

  Map<String, Stat> calculateStats(List<Problem> problems) {
    Map<String, Stat> stats = Map();
    // initialize the 4x4
    for (int i = 1; i <= 4; i++) {
      for (int j = 1; j <= 4; j++) {
        stats['$i-$j'] = Stat(0, 0);
      }
    }
    problems.forEach((p) {
      String key = '${p.gradeA}-${p.gradeB}';
      stats[key].total += 1;
      if (p.sent) stats[key].sent += 1;
    });
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[400],
        title: Text('Weenie Tracker'),
      ),
      body: (_loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              crossAxisCount: 4,
              children: _gridItems,
            ),
    );
  }
}

class StatTile extends StatelessWidget {
  final String label;
  final Stat stat;

  StatTile({
    this.label,
    this.stat,
  });

  @override
  Widget build(BuildContext context) {
    double sentPercent;
    if (stat.total == 0) {
      sentPercent = 0;
    } else {
      sentPercent = stat.sent.toDouble() / stat.total.toDouble(); // [0-1]
    }

    int sentC = (sentPercent * 10).round(); // [0-10]
    int sentP = sentC * 100; // [0-1000]

    Color sentColor;
    if (sentP == 0) {
      sentColor = Colors.teal[50];
    } else if (sentP == 1000) {
      sentColor = Colors.tealAccent;
    } else {
      sentColor = Colors.teal[sentP];
    }

    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: sentColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          Center(
            child: Text(
              '${stat.sent}/${stat.total}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Stat {
  int total;
  int sent;

  Stat(this.total, this.sent);
}
