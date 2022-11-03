Generates Flutter code from Rive files.

rive_generator is a CLI which generates statically typed classes from your Rive files, giving you compile time safety when using artboards, animations and state machine triggers.

# Warning

The package is at an early stage. Changes to the generated files are highly likely at this point.  
If you have comments, suggestions or feature requests, please let me know!

# Usage

Add a dependency or install globally.

Then just run `flutter pub run rive_generator` from the command line.

# What gets generated?

From each rive file the a new file is generated based on the input file name with a rive.dart extension.
The file contains:

- A class named based on the Rive file name.
- Then for each artboard:
  - Classes for each state machine in the artboard.
  - A main class for the artboard containing getters for state machines.
  - A widget that allows to simply load the Artboard with type safe controllers and animations.

For example usages, see the [example](example/lib/main.dart).

# What doesn't get generated?

- Artboards with duplicate names are ignored.
- Artboards with default names are ignored.
