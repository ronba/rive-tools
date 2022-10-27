import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:rive_generator/src/artboard_template.dart';
import 'package:rive_generator/src/rive_reader.dart';
import 'package:yaml/yaml.dart';

class RiveGeneratorConfiguration {
  static final log = Logger('RiveGeneratorConfiguration');
  static const String _riveGeneratorConfigurationKey = 'rive_generator';

  static const String _assetDirectoryKey = "assets";
  static const String _assetDirectoryDefaultValue = "assets";

  static final String _outputDirectoryKey = 'output';
  static final String _outputDirectoryDefaultValue = join('lib', 'rive');

  static final String _formatOutputKey = 'format_output';
  static final bool _formatOutputDefaultValue = true;

  final Directory assetsDirectory; // = "assets";
  final Directory generatedFiledOutput;
  final bool formatOutput;

  factory RiveGeneratorConfiguration.fromYaml(YamlMap pubspec) {
    var assets = _assetDirectoryDefaultValue;
    var outputDirectory = _outputDirectoryDefaultValue;
    var formatOutput = _formatOutputDefaultValue;

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
      }
    }
    return RiveGeneratorConfiguration._(
      assetsDirectory: Directory(assets),
      formatOutput: formatOutput,
      generatedFiledOutput: Directory(outputDirectory),
    );
  }

  RiveGeneratorConfiguration._({
    required this.assetsDirectory,
    required this.formatOutput,
    required this.generatedFiledOutput,
  });

  @override
  String toString() {
    return 'RiveGeneratorConfiguration(assetsDirectory: $assetsDirectory, generatedFiledOutput: $generatedFiledOutput)';
  }
}

void main(List<String> arguments) {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((record) {
    print(
        '[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });
  final log = Logger('main');
  final configuration = RiveGeneratorConfiguration.fromYaml(
      loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap);

  log.info('Loaded configuration: $configuration');

  for (final entity
      in configuration.assetsDirectory.listSync(recursive: true)) {
    if (entity is! File || extension(entity.path) != '.riv') continue;
    final pathWithoutAssets =
        relative(entity.path, from: configuration.assetsDirectory.path);
    final outputFileName = join(configuration.generatedFiledOutput.path,
        setExtension(pathWithoutAssets, '.rive.dart'));
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

    File(outputFileName)
      ..createSync(recursive: true)
      ..writeAsStringSync(lazyRiveFileTemplate(
          RiveInfo(
            className,
            configuration.assetsDirectory.path,
            pathWithoutAssets,
          ),
          rive.artboards.map(GeneratedArtboard.new).toList()
            ..sort(
              (a, b) => a.name.compareTo(b.name),
            )));
  }

  if (configuration.formatOutput) {
    Process.runSync('flutter',
        ['format', configuration.generatedFiledOutput.path, '--fix']);
  }
}
