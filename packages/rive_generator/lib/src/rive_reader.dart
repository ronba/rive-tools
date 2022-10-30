import 'dart:typed_data';

// ignore: implementation_imports
import 'package:rive/src/rive_core/runtime/runtime_header.dart';
// ignore: implementation_imports
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';
import 'package:rive_generator/src/rive_properties.dart';

class Animation {
  final String name;

  Animation(this.name);

  @override
  String toString() {
    return 'Animations(name: $name)';
  }
}

class Artboard {
  final String name;
  List<StateMachine> stateMachines = [];
  Set<Animation> animations = {};

  // The number of times we've seen this name before.
  final int index;

  Artboard(this.name, this.index);

  @override
  String toString() {
    return 'Artboard('
        'name: $name, '
        'animations: $animations, '
        'stateMachines: $stateMachines)';
  }
}

class Context {
  static const int nodeEnd = 0;
  static const int artboard = 1;
  static const int stateMachine = 53;
  static const int stateMachineBool = 59;
  static const int stateMachineTrigger = 58;
  static const int stateMachineDouble = 56;
  static const int linearAnimation = 31;
}

class RiveReader {
  final List<Artboard> artboards;

  RiveReader({required this.artboards});

  factory RiveReader.read(ByteData byteData) {
    final properties = <int, RiveType>{};

    for (final entry in riveProperties.entries) {
      properties[int.parse(entry.key)] = RiveType.fromString(entry.value);
    }

    final reader = BinaryReader.fromList(
      byteData.buffer.asUint8List(),
      endian: Endian.little,
    );

    // CRITICAL!
    // This moves the reader to verify the rive file and skip the ToC.
    RuntimeHeader.read(reader);

    int context = Context.nodeEnd;

    final List<Artboard> artboards = [];

    while (!reader.isEOF) {
      int r = Context.nodeEnd;

      while (r == Context.nodeEnd) {
        r = reader.readVarUint();
      }

      context = r;

      // Each one of the below contexts distinguishes between
      // StateMachineTrigger types, no need to read properties.
      if (context == Context.stateMachineBool) {
        artboards.last.stateMachines.last.triggers
            .add(StateMachineTrigger(StateMachineInputType.boolType));
      }
      if (context == Context.stateMachineTrigger) {
        artboards.last.stateMachines.last.triggers
            .add(StateMachineTrigger(StateMachineInputType.triggerType));
      }
      if (context == Context.stateMachineDouble) {
        artboards.last.stateMachines.last.triggers
            .add(StateMachineTrigger(StateMachineInputType.doubleType));
      }

      // Beginning of new context.
      // Start reading properties. We don't always care about all of them, but
      // we have to go through all of them to get to the next context.
      // Properties are saved in pairs of:
      //   Property Id
      //   Property Value - the value must be read in accordance to its type.

      do {
        // Move to the first property.
        r = reader.readVarUint();
        // Get the property based on the type.
        final type = properties[r];
        switch (type) {
          case RiveType.booleanType:
            reader.readInt8();
            break;
          case RiveType.color:
            reader.readUint32();
            break;
          case RiveType.doubleType:
            reader.readFloat32();
            break;
          case RiveType.stringType:
            final s = reader.readString(explicitLength: true);

            switch (context) {
              case Context.artboard:
                // Artboard name property.
                if (r == 4) {
                  artboards.add(Artboard(
                    s,
                    artboards.where((element) => element.name == s).length,
                  ));
                }
                break;
              case Context.stateMachine:
                artboards.last.stateMachines.add(StateMachine(s));
                break;
              case Context.stateMachineTrigger:
              case Context.stateMachineDouble:
              case Context.stateMachineBool:
                // name
                if (r == 138) {
                  artboards.last.stateMachines.last.triggers.last.name = s;
                }
                break;
              case Context.linearAnimation:
                if (r == 55) {
                  artboards.last.animations.add(Animation(s));
                }
                break;
              default:
                continue;
            }

            break;
          case RiveType.uint:
            reader.readVarUint();
            break;

          case RiveType.bytes:
            var length = reader.readVarUint();
            reader.read(length);
            break;

          case RiveType.unknown:
          case null:
        }
      } while (r != 0);
      context = Context.nodeEnd;
    }

    return RiveReader(artboards: artboards);
  }
}

enum RiveType {
  booleanType,
  bytes,
  color,
  doubleType,
  stringType,
  uint,
  unknown;

  static RiveType fromString(String name) {
    switch (name.toLowerCase()) {
      case "double":
        return RiveType.doubleType;
      case "bytes":
        return RiveType.bytes;
      case "string":
        return RiveType.stringType;
      case "id":
      case "uint":
        return RiveType.uint;
      case "boolean":
      case "bool":
        return RiveType.booleanType;
      case "color":
        return RiveType.color;
    }

    return RiveType.unknown;
  }
}

class StateMachine {
  final String name;
  Set<String> stateNames = {};
  List<StateMachineTrigger> triggers = [];

  StateMachine(this.name);

  @override
  String toString() {
    return 'StateMachine(name: $name, '
        'triggers: $triggers, '
        'stateNames: $stateNames)';
  }
}

enum StateMachineInputType { boolType, doubleType, unknown, triggerType }

class StateMachineTrigger {
  String name = '';
  final StateMachineInputType type;

  StateMachineTrigger(this.type);

  @override
  String toString() {
    return 'StateMachineTrigger(name: $name, type: $type)';
  }
}
