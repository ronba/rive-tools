// ignore_for_file: type=lint
// THIS FILE WAS AUTOMATICALLY GENERATED BY RIVE_GENERATOR. MODIFICATIONS WILL BE LOST WHEN THE GENERATOR RUNS AGAIN.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

const assetsBaseFolder = "assets";

String _assetPath() {
  return (kIsWeb ? '' : assetsBaseFolder + '/') + 'numbers_and_symbols.riv';
}

class Numbers_and_symbols {
  final rive.RiveFile file;
  static String get assetPath => _assetPath();

  Numbers_and_symbols._(this.file);

  static Future<Numbers_and_symbols> load() async {
    final riveFile = rive.RiveFile.import(
        await rootBundle.load(Numbers_and_symbols.assetPath));
    return Numbers_and_symbols._(riveFile);
  }

  T1New$$Artboard_? _m1New$$Artboard_;
  T1New$$Artboard_ get m1New$$Artboard_ =>
      _m1New$$Artboard_ ??= T1New$$Artboard_(file.artboards
          .where((artboard) => artboard.name == r'1 New $$ Artboard_')
          .elementAt(0));
}

class T1New$$Artboard_ {
  final rive.Artboard artboard;
  T1New$$Artboard_(this.artboard);

  T1New$$Artboard_T1Button_StateMachine
      getT1New$$Artboard_T1Button_StateMachine(
          [core.OnStateChange? onStateChange]) {
    return T1New$$Artboard_T1Button_StateMachine(this
        .artboard
        .stateMachineByName("1 Button _", onChange: onStateChange)!);
  }
}

abstract class T1New$$Artboard_Controller {
  abstract final rive.RiveAnimationController controller;
}

class T1New$$Artboard_SimpleAnimation extends T1New$$Artboard_Controller {
  final rive.RiveAnimationController controller;

  T1New$$Artboard_SimpleAnimation(this.controller);
}

class T1New$$Artboard_OneShotAnimation extends T1New$$Artboard_Controller {
  final rive.RiveAnimationController controller;

  T1New$$Artboard_OneShotAnimation(this.controller);
}

enum T1New$$Artboard_Animations {
  m3idle_(r"3 idle_"),
  $4Roll_over(r"$4 Roll_over"),
  m2Press_(r"2 Press_");

  final String name;
  const T1New$$Artboard_Animations(this.name);
  T1New$$Artboard_OneShotAnimation makeOneShotAnimation({
    bool autoplay = true,
    double mix = 1,
    void Function()? onStart,
    void Function()? onStop,
  }) {
    return T1New$$Artboard_OneShotAnimation(rive.OneShotAnimation(this.name,
        autoplay: autoplay, mix: mix, onStart: onStart, onStop: onStop));
  }

  T1New$$Artboard_SimpleAnimation makeSimpleAnimation({
    bool autoplay = true,
    double mix = 1,
  }) {
    return T1New$$Artboard_SimpleAnimation(
        rive.SimpleAnimation(this.name, autoplay: autoplay, mix: mix));
  }

  String toString() {
    return this.name;
  }
}

class T1New$$Artboard_T1Button_StateMachine {
  final rive.StateMachineController controller;
  final rive.SMIBool m35Hover;
  final rive.SMIBool m150Press;
  T1New$$Artboard_T1Button_StateMachine(this.controller)
      : m35Hover = controller.findInput<bool>(r'35 Hover') as rive.SMIBool,
        m150Press = controller.findInput<bool>(r'150 Press') as rive.SMIBool;
}

class T1New$$Artboard_Rive extends StatelessWidget {
  final List<T1New$$Artboard_Animations> animations;
  final Alignment? alignment;
  final bool antialiasing;
  final List<T1New$$Artboard_Controller> controllers;
  final BoxFit? fit;
  final Function(T1New$$Artboard_ artboard)? onInit;
  final Widget? placeHolder;

  const T1New$$Artboard_Rive({
    super.key,
    this.animations = const [],
    this.alignment,
    this.antialiasing = true,
    this.controllers = const [],
    this.fit,
    this.onInit,
    this.placeHolder,
  });

  @override
  Widget build(BuildContext context) {
    return rive.RiveAnimation.asset(
      _assetPath(),
      animations: animations.map((e) => e.name).toList(),
      alignment: alignment,
      antialiasing: antialiasing,
      artboard: r'1 New $$ Artboard_',
      controllers: this.controllers.map((e) => e.controller).toList(),
      fit: fit,
      onInit: (p0) {
        onInit?.call(T1New$$Artboard_(p0));
      },
      placeHolder: placeHolder,
      stateMachines: [],
    );
  }
}
