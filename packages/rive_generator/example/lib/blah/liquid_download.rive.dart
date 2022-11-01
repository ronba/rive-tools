// ignore_for_file: type=lint
// THIS FILE WAS AUTOMATICALLY GENERATED BY RIVE_GENERATOR. MODIFICATIONS WILL BE LOST WHEN THE GENERATOR RUNS AGAIN.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

const assetsBaseFolder = "assets";

class Artboard {
  final rive.Artboard artboard;
  Artboard(this.artboard);

  ArtboardDownloadStateMachine getArtboardDownloadStateMachine(
      [core.OnStateChange? onStateChange]) {
    return ArtboardDownloadStateMachine(
        this.artboard.stateMachineByName("Download", onChange: onStateChange)!);
  }
}

enum ArtboardAnimations {
  demo(r"Demo"),
  complete(r"Complete"),
  indeterminate(r"Indeterminate"),
  determinate(r"Determinate"),
  start(r"Start"),
  idle(r"Idle"),
  reset(r"Reset"),
  zeroDownload(r"ZeroDownload"),
  oneHundredDownload(r"OneHundredDownload");

  final String name;
  const ArtboardAnimations(this.name);
  ArtboardOneShotAnimation makeOneShotAnimation({
    bool autoplay = true,
    double mix = 1,
    void Function()? onStart,
    void Function()? onStop,
  }) {
    return ArtboardOneShotAnimation(rive.OneShotAnimation(this.name,
        autoplay: autoplay, mix: mix, onStart: onStart, onStop: onStop));
  }

  ArtboardSimpleAnimation makeSimpleAnimation({
    bool autoplay = true,
    double mix = 1,
  }) {
    return ArtboardSimpleAnimation(
        rive.SimpleAnimation(this.name, autoplay: autoplay, mix: mix));
  }

  String toString() {
    return this.name;
  }
}

abstract class ArtboardController {
  abstract final rive.RiveAnimationController controller;
}

class ArtboardDownloadStateMachine {
  final rive.StateMachineController controller;
  final rive.SMITrigger download;
  final rive.SMINumber progress;
  final rive.SMINumber indetMix;
  ArtboardDownloadStateMachine(this.controller)
      : download = controller.findInput<bool>(r'Download') as rive.SMITrigger,
        progress = controller.findInput<double>(r'Progress') as rive.SMINumber,
        indetMix = controller.findInput<double>(r'Indet Mix') as rive.SMINumber;
}

class ArtboardOneShotAnimation extends ArtboardController {
  final rive.RiveAnimationController controller;

  ArtboardOneShotAnimation(this.controller);
}

class ArtboardRive extends StatelessWidget {
  final List<ArtboardAnimations> animations;
  final Alignment alignment;
  final bool antialiasing;
  final List<ArtboardController> controllers;
  final BoxFit fit;
  final Function(Artboard artboard)? onInit;
  final Widget placeHolder;

  const ArtboardRive({
    super.key,
    required this.animations,
    required this.alignment,
    required this.antialiasing,
    required this.controllers,
    required this.fit,
    required this.onInit,
    required this.placeHolder,
  });

  @override
  Widget build(BuildContext context) {
    return rive.RiveAnimation.asset(
      Liquid_download.assetPath,
      animations: animations.map((e) => e.name).toList(),
      alignment: alignment,
      antialiasing: antialiasing,
      artboard: 'Artboard',
      controllers: this.controllers.map((e) => e.controller).toList(),
      fit: fit,
      onInit: (p0) {
        onInit?.call(Artboard(p0));
      },
      placeHolder: placeHolder,
      stateMachines: [],
    );
  }
}

class ArtboardSimpleAnimation extends ArtboardController {
  final rive.RiveAnimationController controller;

  ArtboardSimpleAnimation(this.controller);
}

class Liquid_download {
  static String get assetPath {
    return (kIsWeb ? '' : assetsBaseFolder + '/') +
        'samples/liquid_download.riv';
  }

  final rive.RiveFile file;

  Artboard? _artboard;

  Liquid_download._(this.file);

  Artboard get artboard => _artboard ??= Artboard(file.artboards
      .where((artboard) => artboard.name == r'Artboard')
      .elementAt(0));
  static Future<Liquid_download> load() async {
    final riveFile =
        rive.RiveFile.import(await rootBundle.load(Liquid_download.assetPath));
    return Liquid_download._(riveFile);
  }
}