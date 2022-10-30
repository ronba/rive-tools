// ignore_for_file: type=lint
// THIS FILE WAS AUTOMATICALLY GENERATED BY RIVE_GENERATOR. MODIFICATIONS WILL BE LOST WHEN THE GENERATOR RUNS AGAIN.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

const assetsBaseFolder = "assets";

class Liquid_download {
  final rive.RiveFile file;
  static String get assetPath {
    return (kIsWeb ? '' : assetsBaseFolder + '/') +
        'samples/liquid_download.riv';
  }

  Liquid_download._(this.file);

  static Future<Liquid_download> load() async {
    final riveFile =
        rive.RiveFile.import(await rootBundle.load(Liquid_download.assetPath));
    return Liquid_download._(riveFile);
  }

  Artboard? _artboard;
  Artboard get artboard => _artboard ??= Artboard(file.artboards
      .where((artboard) => artboard.name == r'Artboard')
      .elementAt(0));
}

class Artboard {
  final rive.Artboard artboard;
  Artboard(this.artboard);

  final animations = const ArtboardAnimations();

  ArtboardDownloadStateMachine getArtboardDownloadStateMachine(
      [core.OnStateChange? onStateChange]) {
    return ArtboardDownloadStateMachine(
        this.artboard.stateMachineByName("Download", onChange: onStateChange)!);
  }
}

class ArtboardAnimations {
  final String demo = r"Demo";
  final String complete = r"Complete";
  final String indeterminate = r"Indeterminate";
  final String determinate = r"Determinate";
  final String start = r"Start";
  final String idle = r"Idle";
  final String reset = r"Reset";
  final String zeroDownload = r"ZeroDownload";
  final String oneHundredDownload = r"OneHundredDownload";
  const ArtboardAnimations();
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
