// ignore_for_file: type=lint
// THIS FILE WAS AUTOMATICALLY GENERATED BY RIVE_GENERATOR. MODIFICATIONS WILL BE LOST WHEN THE GENERATOR RUNS AGAIN.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

const assetsBaseFolder = "assets";

class Numbers_and_symbols {
  final rive.RiveFile file;
  static String get assetPath {
    return (kIsWeb ? '' : assetsBaseFolder + '/') + 'numbers_and_symbols.riv';
  }

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

  final animations = const T1New$$Artboard_Animations();

  T1New$$Artboard_T1Button_StateMachine
      getT1New$$Artboard_T1Button_StateMachine(
          [core.OnStateChange? onStateChange]) {
    return T1New$$Artboard_T1Button_StateMachine(this
        .artboard
        .stateMachineByName("1 Button _", onChange: onStateChange)!);
  }
}

class T1New$$Artboard_Animations {
  final String m3idle_ = r"3 idle_";
  final String $4Roll_over = r"$4 Roll_over";
  final String m2Press_ = r"2 Press_";
  const T1New$$Artboard_Animations();
}

class T1New$$Artboard_T1Button_StateMachine {
  final rive.StateMachineController controller;
  final rive.SMIBool m35Hover;
  final rive.SMIBool m150Press;
  T1New$$Artboard_T1Button_StateMachine(this.controller)
      : m35Hover = controller.findInput<bool>(r'35 Hover') as rive.SMIBool,
        m150Press = controller.findInput<bool>(r'150 Press') as rive.SMIBool;
}
