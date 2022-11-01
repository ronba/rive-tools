// import 'package:flutter/src/widgets/framework.dart';
// import 'package:rive/rive.dart';

// Widget foo(BuildContext context) {
//   return const Whatever<Moo>(
//     animations: [Moo.a, Moo.b, Moo.c],
//   );
// }

// void foo1(RiveFile riveFile) {
//   ['a', 'a', 'c'].where.map(
//         (e) => e,
//       );
// }

enum Moo implements Value {
  a('a'),
  b('b'),
  c('c');

  @override
  final String value;
  const Moo(this.value);
}

abstract class Value {
  abstract final String value;
}

class Foo2 {
  Moo a = ;
}

// class Whatever<T extends Value> extends StatelessWidget {
//   final List<T> animations;

//   const Whatever({super.key, required this.animations});

//   @override
//   Widget build(BuildContext context) {
//     return RiveAnimation.asset(
//       'abc',
//       animations: animations.map((e) => e.value).toList(),
//     );
//   }
// }


