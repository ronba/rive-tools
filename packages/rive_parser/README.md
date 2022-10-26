Given a path creates a map of rive properties mapped to their type.

For example:

```bash
echo final riveProperties= $(dart run packages/rive_parser/bin/rive_parser.dart third_party/submodules/rive-cpp/dev/defs/)";" > packages/rive_generator/lib/src/rive_properties.dart
```
