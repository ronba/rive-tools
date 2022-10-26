import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

void main(List<String> arguments) {
  final Map<String, String> properties = {};

  final nodeProperties = Directory(arguments[0])
      .listSync(recursive: true)
      .where((element) => p.extension(element.path) == '.json')
      .whereType<File>()
      .map((e) => jsonDecode(e.readAsStringSync()))
      .where((element) => element.containsKey('properties'))
      .map((e) => e['properties'])
      .whereType<Map<String, dynamic>>();

  for (final configuration in nodeProperties) {
    for (var e in configuration.values) {
      properties[e['key']['int'].toString()] = e['type'];
    }
  }

  print(json.encode(Map.fromEntries(properties.entries.toList()
        ..sort((e1, e2) => e1.key.compareTo(e2.key)))
      .map((key, value) => MapEntry(key.toString(), value))));
}
