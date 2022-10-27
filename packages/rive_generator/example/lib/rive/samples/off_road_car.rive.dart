// ignore_for_file: type=lint
// THIS FILE WAS AUTOMATICALLY GENERATED BY RIVE_GENERATOR. MODIFICATIONS WILL BE LOST WHEN THE GENERATOR RUNS AGAIN.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

const assetsBaseFolder = "assets";

class Off_road_car {
  final rive.RiveFile file;
  static String get assetPath {
    return (kIsWeb ? '' : assetsBaseFolder + '/') + 'samples/off_road_car.riv';
  }

  Off_road_car._(this.file);

  static Future<Off_road_car> load() async {
    final riveFile =
        rive.RiveFile.import(await rootBundle.load(Off_road_car.assetPath));
    return Off_road_car._(riveFile);
  }

  NewArtboard? _newArtboard;
  NewArtboard get newArtboard =>
      _newArtboard ??= NewArtboard(file.artboardByName(r'New Artboard')!);
}

class NewArtboard {
  final rive.Artboard artboard;
  NewArtboard(this.artboard);

  final animations = const NewArtboardAnimations();

  NewArtboardStateMachine1StateMachine getNewArtboardStateMachine1StateMachine(
      [core.OnStateChange? onStateChange]) {
    return NewArtboardStateMachine1StateMachine(this
        .artboard
        .stateMachineByName("State Machine 1", onChange: onStateChange)!);
  }
}

class NewArtboardAnimations {
  final String idle = r"idle";
  final String bouncing = r"bouncing";
  final String windshield_wipers = r"windshield_wipers";
  final String broken = r"broken";
  final String untitled1 = r"Untitled 1";
  const NewArtboardAnimations();
}

class NewArtboardStateMachine1StateMachine {
  final rive.StateMachineController controller;

  NewArtboardStateMachine1StateMachine(this.controller);
}
