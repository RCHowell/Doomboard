import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model.dart';

class FilterDialog extends StatefulWidget {
  final Filter filter;

  FilterDialog(this.filter);

  @override
  State<StatefulWidget> createState() => _FilterDialogState(filter);
}

class _FilterDialogState extends State<FilterDialog> {
  Filter filter;

  List<String> _qualityLabels = [
    'BOMBS',
    '0',
    'STARS',
  ];

  List<String> _gradeBLabels = [
    'A',
    'B',
    'C',
    'D',
  ];

  _FilterDialogState(this.filter);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filters'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('#'),
              RangeSlider(
                values: RangeValues(
                  filter.minGradeA.toDouble(),
                  filter.maxGradeA.toDouble(),
                ),
                labels: RangeLabels(
                  filter.minGradeA.toString(),
                  filter.maxGradeA.toString(),
                ),
                min: 1.0,
                max: 4.0,
                divisions: 3,
                onChanged: (RangeValues rv) {
                  setState(() {
                    filter.minGradeA = rv.start.toInt();
                    filter.maxGradeA = rv.end.toInt();
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('X'),
              RangeSlider(
                values: RangeValues(
                  filter.minGradeB.toDouble(),
                  filter.maxGradeB.toDouble(),
                ),
                labels: RangeLabels(
                  _gradeBLabels[filter.minGradeB - 1],
                  _gradeBLabels[filter.maxGradeB - 1],
                ),
                min: 1.0,
                max: 4.0,
                divisions: 3,
                onChanged: (RangeValues rv) {
                  setState(() {
                    filter.minGradeB = rv.start.toInt();
                    filter.maxGradeB = rv.end.toInt();
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Q'),
              RangeSlider(
                values: RangeValues(
                    filter.minQuality.toDouble(), filter.maxQuality.toDouble()),
                labels: RangeLabels(
                  _qualityLabels[filter.minQuality + 1],
                  _qualityLabels[filter.maxQuality + 1],
                ),
                min: -1.0,
                max: 1.0,
                divisions: 2,
                onChanged: (RangeValues rv) {
                  setState(() {
                    filter.minQuality = rv.start.toInt();
                    filter.maxQuality = rv.end.toInt();
                  });
                },
              ),
            ],
          ),
          CheckboxListTile(
            value: filter.hideSends,
            onChanged: (bool v) {
              setState(() {
                filter.hideSends = v;
              });
            },
            title: Text('Exclude Sends'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(this.filter),
        ),
      ],
    );
  }
}
