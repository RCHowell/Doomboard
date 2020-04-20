import 'package:campus_19/repo.dart';
import 'package:campus_19/views/problems_view.dart';

import '../model.dart';

class ProblemsController {
  final ProblemsViewContract _view;
  final Repo _repo;

  ProblemsController(this._view, this._repo);

  void getProblems(Filter f, String s) {
    _repo
        .get(f, s)
        .then(_view.onGetProblemsSuccess)
        .catchError(_view.showError);
  }

  void update(Problem p) {
    _repo.update(p).catchError(_view.showError);
  }
}
