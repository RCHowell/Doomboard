import 'package:campus_19/controllers/problems_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model.dart';

class ProblemTile extends StatelessWidget {
  final Problem problem;
  final Function onLongPress;
  final Function onTap;

  final List<String> _gradeBLabels = [
    'A',
    'B',
    'C',
    'D',
  ];

  ProblemTile({this.problem, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    Widget chipAvatar;
    if (problem.quality == Quality.BOMB) {
      chipAvatar = FaIcon(
        FontAwesomeIcons.bomb,
        size: 14.0,
        color: Colors.black,
      );
    } else if (problem.quality == Quality.STAR) {
      chipAvatar = FaIcon(
        FontAwesomeIcons.solidStar,
        size: 14.0,
        color: Colors.yellow[600],
      );
    }

    List<TextSpan> _titleText = List();
    if (problem.sent) {
      _titleText.add(TextSpan(
        text: '\u{2022} ',
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.red,
        ),
      ));
    }
    _titleText.add(TextSpan(text: problem.name));

    List<Widget> _subtitle = List();
    _subtitle.add(Text(problem.moves.join(' > ')));
    if (problem.spray.isNotEmpty) {
      _subtitle.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: FaIcon(
          FontAwesomeIcons.comment,
          size: 12.0,
          color: Colors.blueGrey[200],
        ),
      ));
    }

    List<Color> gradeColors = [
      Colors.tealAccent[200],
      Colors.amberAccent[100],
      Colors.redAccent[100],
      Colors.lightBlueAccent[100],
    ];

    return ListTile(
      onLongPress: onLongPress,
      onTap: onTap,
      title: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          children: _titleText,
        ),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _subtitle,
      ),
      trailing: Chip(
        avatar: chipAvatar,
        backgroundColor: gradeColors[problem.gradeA - 1],
        label: Text(
          '${problem.gradeA}${_gradeBLabels[problem.gradeB - 1]}',
//          style: TextStyle(
//            fontWeight: FontWeight.bold,
//          ),
        ),
        elevation: 1.0,
      ),
    );
  }
}
