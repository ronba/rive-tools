// ignore_for_file: type=lint
// THIS FILE WAS AUTOMATICALLY GENERATED BY RIVE_GENERATOR. MODIFICATIONS WILL BE LOST WHEN THE GENERATOR RUNS AGAIN.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

const assetsBaseFolder = "assets";

class Skills {
  final rive.RiveFile file;
  static String get assetPath {
    return (kIsWeb ? '' : assetsBaseFolder + '/') + 'samples/skills.riv';
  }

  Skills._(this.file);

  static Future<Skills> load() async {
    final riveFile =
        rive.RiveFile.import(await rootBundle.load(Skills.assetPath));
    return Skills._(riveFile);
  }

  NewArtboard? _newArtboard;
  NewArtboard get newArtboard =>
      _newArtboard ??= NewArtboard(file.artboardByName('New Artboard')!);
}

class NewArtboard {
  final rive.Artboard artboard;
  NewArtboard(this.artboard);

  final animations = const NewArtboardAnimations();

  NewArtboardDesignersTestStateMachine getNewArtboardDesignersTestStateMachine(
      [core.OnStateChange? onStateChange]) {
    return NewArtboardDesignersTestStateMachine(this
        .artboard
        .stateMachineByName("Designer's Test", onChange: onStateChange)!);
  }

  NewArtboardStateMachine1StateMachine getNewArtboardStateMachine1StateMachine(
      [core.OnStateChange? onStateChange]) {
    return NewArtboardStateMachine1StateMachine(this
        .artboard
        .stateMachineByName("State Machine 1", onChange: onStateChange)!);
  }
}

class NewArtboardAnimations {
  final String expert_idle = "Expert_idle";
  final String expert_hover = "Expert_hover";
  final String expert_press = "Expert_press";
  final String intermediate_idle = "Intermediate_idle";
  final String intermediate_hover = "Intermediate_hover";
  final String intermediate_press = "Intermediate_press";
  final String beginner_idle = "Beginner_idle";
  final String beginner_hover = "Beginner_hover";
  final String beginner_press = "Beginner_press";
  final String beginner = "Beginner";
  final String intermediate = "Intermediate";
  final String expert = "Expert";
  final String test = "Test";
  const NewArtboardAnimations();
}

class NewArtboardDesignersTestStateMachine {
  final rive.StateMachineController controller;
  final rive.SMINumber level;
  NewArtboardDesignersTestStateMachine(this.controller)
      : level = controller.findInput<double>('Level') as rive.SMINumber;
}

class NewArtboardStateMachine1StateMachine {
  final rive.StateMachineController controller;
  final rive.SMIBool intermediate;
  final rive.SMIBool expert;
  NewArtboardStateMachine1StateMachine(this.controller)
      : intermediate =
            controller.findInput<bool>('Intermediate ') as rive.SMIBool,
        expert = controller.findInput<bool>('Expert') as rive.SMIBool;
}