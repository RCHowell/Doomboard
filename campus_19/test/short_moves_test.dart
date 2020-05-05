import 'package:campus_19/model.dart';
import 'package:test/test.dart';

void main() {
  test('Short Moves', () {
    List<String> out = Problem.shortMoves(['AB', 'BC', 'CD', 'DE', 'EF']);
    print(out);
    List<String> expected = ['AB', 'C', 'D', 'E', 'F'];
    expect(out, equals(expected));
  });
}