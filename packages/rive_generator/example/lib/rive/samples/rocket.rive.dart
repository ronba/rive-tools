// ignore_for_file: type=lint
// THIS FILE WAS AUTOMATICALLY GENERATED BY RIVE_GENERATOR. MODIFICATIONS WILL BE LOST WHEN THE GENERATOR RUNS AGAIN.
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

class Rocket {
  final rive.RiveFile file;
  static final assetPath = 'samples/rocket.riv';

  Rocket._(this.file);
  
  static Future<Rocket> load() async {
    final riveFile = rive.RiveFile.import(await rootBundle.load('samples/rocket.riv')); 
    return Rocket._(riveFile);
  }

  NewArtboard? _newArtboard;
  NewArtboard get newArtboard => _newArtboard ??= NewArtboard(file.artboardByName('New Artboard')!);
    

}

class NewArtboard {
  final rive.Artboard artboard;
  NewArtboard(this.artboard);

  final animations = const NewArtboardAnimations();

  NewArtboardButtonStateMachine getNewArtboardButtonStateMachine([core.OnStateChange? onStateChange]) {
    return NewArtboardButtonStateMachine(this.artboard.stateMachineByName("Button",onChange: onStateChange)!);
  }
}

class NewArtboardAnimations {
  final String idle = "idle";
  final String roll_over = "Roll_over";
  final String press = "Press";
  const NewArtboardAnimations();
}

class NewArtboardButtonStateMachine {
  final rive.StateMachineController controller;
  final rive.SMIBool hover;
  final rive.SMIBool press;
  NewArtboardButtonStateMachine(this.controller) :
    hover = controller.findInput<bool>('Hover') as rive.SMIBool,
    press = controller.findInput<bool>('Press') as rive.SMIBool;
}


 