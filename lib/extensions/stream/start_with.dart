import 'package:async/async.dart' show StreamGroup;

extension StartWith<T> on Stream<T> {
  /*

  this:             |
  Stream.value:    | X |
  merge           | X ----------- X ------------- X

  */

  Stream<T> startWith(T value) => StreamGroup.merge([
        this,
        Stream<T>.value(value),
      ]);
}
