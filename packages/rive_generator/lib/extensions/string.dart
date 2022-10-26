extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String unCapitalize() {
    return "${this[0].toLowerCase()}${substring(1)}";
  }

  String removeWhitespace() {
    return replaceAll(' ', '');
  }

  String removeIllegalCharacters() {
    return replaceAll(RegExp(r'[^A-Za-z0-9$_]'), '');
  }
}
