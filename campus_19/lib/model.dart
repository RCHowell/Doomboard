enum Quality { BOMB, UNRATED, STAR }

enum SortChoice {
  Quality,
  GradeA,
  GradeB,
  Alpha,
}

class Problem {
  int id;
  String name;
  String spray;
  List<String> moves;
  Quality quality;
  int gradeA;
  int gradeB;
  bool sent;

  Problem(
      {this.id,
      this.name,
      this.spray,
      this.moves,
      this.quality,
      this.gradeA,
      this.gradeB,
      this.sent});

  Problem.fromMap(map) {
    id = map['id'];
    name = map['name'];
    spray = map['spray'];
    moves = map['moves'].split(',');
    gradeA = map['grade_a'];
    gradeB = map['grade_b'];
    sent = map['sent'] == 1;
    switch (map['quality']) {
      case 1:
        quality = Quality.STAR;
        break;
      case -1:
        quality = Quality.BOMB;
        break;
      default:
        quality = Quality.UNRATED;
        break;
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'spray': spray,
      'moves': moves.join(','),
      'grade_a': gradeA,
      'grade_b': gradeB,
      'sent': (sent) ? 1 : 0,
    };

    switch (quality) {
      case Quality.BOMB:
        map['quality'] = -1;
        break;
      case Quality.UNRATED:
        map['quality'] = 0;
        // TODO: Handle this case.
        break;
      case Quality.STAR:
        map['quality'] = 1;
        break;
    }

    return map;
  }
}

class Filter {
  bool hideSends;
  int minQuality;
  int maxQuality;
  int minGradeA;
  int maxGradeA;
  int minGradeB;
  int maxGradeB;

  Filter(
    this.hideSends,
    this.minQuality,
    this.maxQuality,
    this.minGradeA,
    this.maxGradeA,
    this.minGradeB,
    this.maxGradeB,
  );

  Filter.empty() : this(false, -1, 1, 1, 4, 1, 4);

  Map<String, String> toMap() => {
        'quality': '$minQuality-$maxQuality',
        'gradeA': '$minGradeA-$maxGradeA',
        'gradeB': '$minGradeB-$maxGradeB',
        'hideSent': hideSends.toString(),
      };
}
