import 'package:rive_generator/extensions/string.dart';
import 'package:rive_generator/src/rive_reader.dart';

String lazyRiveFileTemplate(
    RiveInfo riveInfo, List<GeneratedArtboard> generatedArtboards) {
  final mainRiveClassName = riveInfo.name.asType;

  return '''
// ignore_for_file: type=lint
// THIS FILE WAS AUTOMATICALLY GENERATED BY RIVE_GENERATOR. MODIFICATIONS WILL BE LOST WHEN THE GENERATOR RUNS AGAIN.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

const assetsBaseFolder = "${riveInfo.assetBaseFolder}";

String _assetPath() {
    return (kIsWeb ? '' : assetsBaseFolder + '/') + '${riveInfo.assetPath}';
  }

class $mainRiveClassName {
  final rive.RiveFile file;
  static String get assetPath => _assetPath();

  $mainRiveClassName._(this.file);
  
  static Future<$mainRiveClassName> load() async {
    final riveFile = rive.RiveFile.import(await rootBundle.load($mainRiveClassName.assetPath)); 
    return $mainRiveClassName._(riveFile);
  }

${generatedArtboards.map((e) {
    final lower = e.member;
    return '''
  ${e.type}? _$lower;
  ${e.type} get $lower => _$lower ??= ${e.type}(file.artboards.where((artboard) => artboard.name == r'${e.name}').elementAt(${e.artboard.index}));
    ''';
  }).join('\n')}

}

${generatedArtboards.map((e) => e.generatedClass()).join('\n')}
 ''';
}

class GeneratedArtboard {
  final Artboard artboard;
  final String member;
  final String name;
  final String type;

  GeneratedArtboard(this.artboard, this.member, this.type)
      : name = artboard.name;

  String generatedClass() {
    final animationClassName = '${type}Animations';

    final stateMachines = artboard.stateMachines.map((e) {
      final stateMachineSymbol = GeneratedSymbol(e.name);

      final stateMachineClassName =
          '$type${stateMachineSymbol.asType}StateMachine';

      final triggers = e.triggers
          .where((element) =>
              element.type != StateMachineInputType.unknown &&
              element.name.isNotEmpty)
          .map((e) => getTriggers(e));

      return [
        '''
class $stateMachineClassName {
  final rive.StateMachineController controller;
${triggers.map((e) => '  ${e[0]}').join('\n')}
  $stateMachineClassName(this.controller) ${triggers.isNotEmpty ? (':\n${triggers.map((e) => '    ${e[1]}').join(',\n')}') : ''};
}
''',
        '''
$stateMachineClassName get$stateMachineClassName([core.OnStateChange? onStateChange]) {
    return $stateMachineClassName(this.artboard.stateMachineByName("${e.name}",onChange: onStateChange)!);
  }'''
      ];
    });

    return '''
class $type {
  final rive.Artboard artboard;
  $type(this.artboard);

  ${stateMachines.map((e) => e[1]).join('\n')}
}

${artboard.animations.isNotEmpty ? '''

abstract class ${type}Controller {
  abstract final rive.RiveAnimationController controller;
}

class ${type}SimpleAnimation extends ${type}Controller {
  final rive.RiveAnimationController controller;

  ${type}SimpleAnimation(this.controller);
}

class ${type}OneShotAnimation extends ${type}Controller {
  final rive.RiveAnimationController controller;

  ${type}OneShotAnimation(this.controller);
}

enum $animationClassName {
${artboard.animations.map((e) => '  ${GeneratedSymbol(e.name).asMember}(r"${e.name}")').join(',\n')};
  final String name;
  const $animationClassName(this.name);
  ${type}OneShotAnimation makeOneShotAnimation({
    bool autoplay = true,
    double mix = 1,
    void Function()? onStart,
    void Function()? onStop,
  }) {
    return ${type}OneShotAnimation(rive.OneShotAnimation(this.name,
        autoplay: autoplay, mix: mix, onStart: onStart, onStop: onStop));
  }

  ${type}SimpleAnimation makeSimpleAnimation({
    bool autoplay = true,
    double mix = 1,
  }) {
    return ${type}SimpleAnimation(rive.SimpleAnimation(this.name, autoplay: autoplay, mix: mix));
  }

  String toString() {
    return this.name;
  }
}
''' : ''}

${stateMachines.map((e) => e[0]).join('\n')}

class ${type}Rive extends StatelessWidget {
  final List<${type}Animations> animations;
  final Alignment? alignment;
  final bool antialiasing;
  final List<${type}Controller> controllers;
  final BoxFit? fit;
  final Function($type artboard)? onInit;
  final Widget? placeHolder;

  const ${type}Rive({
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
      artboard: r'$name',
      controllers: this.controllers.map((e) => e.controller).toList(),
      fit: fit,
      onInit: (p0) {
        onInit?.call($type(p0));
      },
      placeHolder: placeHolder,
      stateMachines: [],
    );
  }
}
''';
  }

  List<String> getTriggers(StateMachineTrigger trigger) {
    final triggerName = GeneratedSymbol(trigger.name);

    var triggerType = '';
    var functionCall = '';
    switch (trigger.type) {
      case StateMachineInputType.boolType:
        triggerType = 'rive.SMIBool';
        functionCall =
            "controller.findInput<bool>(r'${trigger.name}') as $triggerType";
        break;
      case StateMachineInputType.doubleType:
        triggerType = 'rive.SMINumber';
        functionCall =
            "controller.findInput<double>(r'${trigger.name}') as $triggerType";
        break;
      case StateMachineInputType.triggerType:
        triggerType = 'rive.SMITrigger';
        functionCall =
            "controller.findInput<bool>(r'${trigger.name}') as $triggerType";
        break;
      case StateMachineInputType.unknown:
        '';
    }

    return [
      'final $triggerType ${triggerName.asMember};',
      '${triggerName.asMember} = $functionCall'
    ];
  }
}

class GeneratedSymbol {
  final String input;

  GeneratedSymbol(this.input);

  String get asMember {
    return _handleNumbersOnStart(
      _removeIllegalCharacters(input.unCapitalize().removeWhitespace()),
      'm',
    );
  }

  String get asType {
    return _handleNumbersOnStart(
      _removeIllegalCharacters(input.capitalize().removeWhitespace()),
      'T',
    );
  }

  String _handleNumbersOnStart(String input, String replaceStart) {
    if (input.startsWith(RegExp(r'[0-9]'))) {
      return '$replaceStart$input';
    }
    return input;
  }

  static String _removeIllegalCharacters(String input) {
    return input.replaceAll(RegExp(r'[^A-Za-z0-9$_]'), '');
  }
}

class RiveInfo {
  final String assetBaseFolder;
  final String assetPath;
  final GeneratedSymbol name;

  RiveInfo(String name, this.assetBaseFolder, this.assetPath)
      : name = GeneratedSymbol(name);
}
