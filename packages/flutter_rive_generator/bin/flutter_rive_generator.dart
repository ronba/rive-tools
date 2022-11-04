import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_rive_generator/src/artboard_template.dart';
import 'package:flutter_rive_generator/src/rive_reader.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

void main(List<String> arguments) {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((record) {
    print(
        '[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });
  final log = Logger('main');
  final configuration = RiveGeneratorConfiguration.fromYaml(
      loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap);

  log.config('Loaded configuration: $configuration');

  if (configuration.clearGeneratedFileOutput) {
    configuration.generatedFiledOutput
        .listSync(recursive: true)
        .whereType<File>()
        .where(
            (element) => extension(element.path, 2) == generatedFileExtension)
        .forEach((element) {
      log.info('Removing element: ${element.path}.');
      element.deleteSync();
    });
  }

  for (final entity
      in configuration.assetsDirectory.listSync(recursive: true)) {
    if (entity is! File || extension(entity.path) != '.riv') continue;
    final pathWithoutAssets =
        relative(entity.path, from: configuration.assetsDirectory.path);
    final outputFileName = join(configuration.generatedFiledOutput.path,
        setExtension(pathWithoutAssets, generatedFileExtension));
    log.finest('Generated file name: ${entity.path} -> $outputFileName');

    RiveReader? rive;
    try {
      rive = RiveReader.read(ByteData.view(entity.readAsBytesSync().buffer));
    } catch (e, s) {
      log.warning('Failed to parse ${entity.path}.', e, s);
      print(e);
      print(s);
      continue;
    }

    final className = setExtension(basename(entity.path), '');

    final artboardsByName = <String, List<Artboard>>{};
    for (var artboard in rive.artboards) {
      if (artboardsByName.containsKey(artboard.name)) {
        artboardsByName[artboard.name]!.add(artboard);
      } else {
        artboardsByName[artboard.name] = [artboard];
      }
    }

    final List<GeneratedArtboard> generatedArtboards = [];
    for (var artboardByName in artboardsByName.entries) {
      final warnings = <String>[];
      if (artboardByName.value.length > 1) {
        warnings.add('Multiple artboards with the same name are not allowed. ');
      }

      if (artboardByName.key == defaultArtboardName) {
        warnings.add(
          'Artboards with the default name "$defaultArtboardName" will be '
          'skipped. To generate code for this artboard, change its name.',
        );
      }

      if (warnings.isNotEmpty) {
        log.warning(
          'Skipping code generation for artboard(s) with name "${artboardByName.key}":'
          '\n${warnings.map((e) => '  - $e').join('\n')}',
        );

        continue;
      }

      final artboard = artboardByName.value.first;
      final symbol = GeneratedSymbol(artboard.name);

      generatedArtboards
          .add(GeneratedArtboard(artboard, symbol.asMember, symbol.asType));
    }

    var posixPathWithoutAssets = pathWithoutAssets;
    var posixAssetsBaseFolder = relative(
      configuration.assetsDirectory.path,
      from: current,
    );
    if (Platform.isWindows) {
      posixPathWithoutAssets =
          posix.joinAll(windows.split(posixPathWithoutAssets));
      posixAssetsBaseFolder =
          posix.joinAll(windows.split(posixAssetsBaseFolder));
    }

    if (generatedArtboards.isEmpty) {
      log.warning('File ${entity.path} has no artboards. Skipping generation.');
      continue;
    }
    File(outputFileName)
      ..createSync(recursive: true)
      ..writeAsStringSync(lazyRiveFileTemplate(
          RiveInfo(
            className,
            posixAssetsBaseFolder,
            posixPathWithoutAssets,
          ),
          generatedArtboards
            ..sort(
              (a, b) => a.name.compareTo(b.name),
            )));
  }

  if (configuration.formatOutput) {
    var generatedOutputPath = configuration.generatedFiledOutput.path;
    if (Platform.isWindows) {
      generatedOutputPath = windows.joinAll(posix.split(generatedOutputPath));
    }
    Process.runSync(
      'flutter',
      ['format', generatedOutputPath, '--fix'],
      runInShell: true,
    );
  }
}

const String defaultArtboardName = "New Artboard";

const String generatedFileExtension = '.rive.dart';

class RiveGeneratorConfiguration {
  static final log = Logger('RiveGeneratorConfiguration');
  static const String _riveGeneratorConfigurationKey = 'flutter_rive_generator';

  static const String _assetDirectoryKey = "assets";
  static const String _assetDirectoryDefaultValue = "assets";

  static final String _outputDirectoryKey = 'output';
  static final String _outputDirectoryDefaultValue = join('lib', 'rive');

  static final String _formatOutputKey = 'format_output';
  static final bool _formatOutputDefaultValue = true;

  static final String _clearOutputBeforeGenerationKey =
      'clear_output_directory_before_generation';
  static final bool _clearOutputBeforeGenerationValue = true;

  final Directory assetsDirectory;
  final Directory generatedFiledOutput;
  final bool clearGeneratedFileOutput;
  final bool formatOutput;

  factory RiveGeneratorConfiguration.fromYaml(YamlMap pubspec) {
    var assets = _assetDirectoryDefaultValue;
    var outputDirectory = _outputDirectoryDefaultValue;
    var formatOutput = _formatOutputDefaultValue;
    var clearOutputBeforeGeneration = _clearOutputBeforeGenerationValue;

    if (pubspec.containsKey(_riveGeneratorConfigurationKey)) {
      final configuration = pubspec[_riveGeneratorConfigurationKey];
      log.fine('Found configuration: $configuration');
      if (configuration is YamlMap) {
        if (configuration.containsKey(_assetDirectoryKey)) {
          assets = configuration[_assetDirectoryKey];
          // Sanitize directory path ending with '/'.
          if (assets.endsWith('/')) {
            assets = assets.substring(0, assets.length - 1);
          }
        }
        if (configuration.containsKey(_outputDirectoryKey)) {
          outputDirectory = configuration[_outputDirectoryKey];
        }
        if (configuration.containsKey(_formatOutputKey)) {
          formatOutput = configuration[_formatOutputKey];
        }
        if (configuration.containsKey(_clearOutputBeforeGenerationKey)) {
          clearOutputBeforeGeneration =
              configuration[_clearOutputBeforeGenerationKey];
        }
      }
    }

    return RiveGeneratorConfiguration._(
      assetsDirectory: Directory(join(current, assets)),
      formatOutput: formatOutput,
      generatedFiledOutput: Directory(join(current, outputDirectory)),
      clearGeneratedFileOutput: clearOutputBeforeGeneration,
    );
  }

  RiveGeneratorConfiguration._({
    required this.assetsDirectory,
    required this.formatOutput,
    required this.generatedFiledOutput,
    required this.clearGeneratedFileOutput,
  });

  @override
  String toString() {
    return 'RiveGeneratorConfiguration('
        'assetsDirectory: $assetsDirectory, '
        'generatedFiledOutput: $generatedFiledOutput, '
        'clearGeneratedFileOutput: $clearGeneratedFileOutput, '
        'formatOutput: $formatOutput)';
  }
}
