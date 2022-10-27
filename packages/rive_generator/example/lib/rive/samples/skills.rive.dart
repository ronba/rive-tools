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
      _newArtboard ??= NewArtboard(file.artboardByName(r'New Artboard')!);
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
  final String expert_idle = r"Expert_idle";
  final String expert_hover = r"Expert_hover";
  final String expert_press = r"Expert_press";
  final String intermediate_idle = r"Intermediate_idle";
  final String intermediate_hover = r"Intermediate_hover";
  final String intermediate_press = r"Intermediate_press";
  final String beginner_idle = r"Beginner_idle";
  final String beginner_hover = r"Beginner_hover";
  final String beginner_press = r"Beginner_press";
  final String beginner = r"Beginner";
  final String intermediate = r"Intermediate";
  final String expert = r"Expert";
  final String test = r"Test";
  const NewArtboardAnimations();
}

class NewArtboardDesignersTestStateMachine {
  final rive.StateMachineController controller;
  final rive.SMINumber level;
  NewArtboardDesignersTestStateMachine(this.controller)
      : level = controller.findInput<double>(r'Level') as rive.SMINumber;
}

class NewArtboardStateMachine1StateMachine {
  final rive.StateMachineController controller;
  final rive.SMIBool intermediate;
  final rive.SMIBool expert;
  NewArtboardStateMachine1StateMachine(this.controller)
      : intermediate =
            controller.findInput<bool>(r'Intermediate ') as rive.SMIBool,
        expert = controller.findInput<bool>(r'Expert') as rive.SMIBool;
}
