import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model.dart';

class ProblemDialog extends StatefulWidget {
  final Problem problem;

  ProblemDialog({
    this.problem,
  });

  @override
  State<StatefulWidget> createState() => _ProblemDialogState(this.problem);
}

class _ProblemDialogState extends State<ProblemDialog> {
  final Problem p;

  _ProblemDialogState(this.p);

  Widget getFab(Widget child, Color color, Quality q) => FloatingActionButton(
        elevation: 2.0,
        onPressed: () {
          setState(() {
            p.quality = q;
          });
        },
        backgroundColor: color,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    FloatingActionButton fab;
    switch (p.quality) {
      case Quality.STAR:
        fab = getFab(
            FaIcon(
              FontAwesomeIcons.solidStar,
              color: Colors.yellow[600],
            ),
            Colors.yellow[100],
            Quality.UNRATED);
        break;
      case Quality.BOMB:
        fab = getFab(
            FaIcon(
              FontAwesomeIcons.bomb,
              color: Colors.black,
            ),
            Colors.blueGrey[50],
            Quality.STAR);
        break;
      case Quality.UNRATED:
        fab = getFab(
            FaIcon(
              FontAwesomeIcons.creativeCommonsZero,
              color: Colors.blueGrey[500],
            ),
            Colors.white,
            Quality.BOMB);
        break;
    }

    return AlertDialog(
      title: Text(p.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            minLines: 3,
            maxLines: 3,
            maxLength: 140,
            controller: TextEditingController(
              text: p.spray,
            ),
            onChanged: (val) => p.spray = val,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          fab,
        ],
      ),
      actions: [
        FlatButton(
          child: Text('EXIT'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        FlatButton(
          child: Text('SAVE'),
          onPressed: () => Navigator.of(context).pop(this.p),
        ),
      ],
    );
  }
}
