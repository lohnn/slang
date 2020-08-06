import 'package:fast_i18n/utils.dart';

class I18nConfig {
  final String baseLocale; // defaults to ''
  final List<String> maps; // list of entities treated as maps and not classes

  I18nConfig(this.baseLocale, this.maps);

  @override
  String toString() => '$baseLocale, maps: $maps';
}

/// represents one locale and its localized strings
class I18nData {
  final I18nConfig globalConfig; // config of all locales
  final String baseName; // name of all i18n files, like strings or messages
  final bool base; // whether or not this is the base locale
  final String locale; // the locale code (the part after the underscore)
  final ObjectNode root; // the actual strings

  I18nData(this.globalConfig, this.baseName, this.locale, this.root)
      : base = locale == globalConfig.baseLocale;
}

class Value {}

class ObjectNode extends Value {
  final Map<String, Value> entries;
  final bool mapMode;
  final bool plainStrings;

  ObjectNode(this.entries, this.mapMode) : plainStrings = entries.values.every((child) => child is TextNode && child.params.isEmpty);

  @override
  String toString() => entries.toString();
}

class ListNode extends Value {
  final List<Value> entries;
  final bool plainStrings;

  ListNode(this.entries) : plainStrings = entries.every((child) => child is TextNode && child.params.isEmpty);

  @override
  String toString() => entries.toString();
}

class TextNode extends Value {
  final String content;
  final List<String> params;

  TextNode(String content)
      : content = content
            .replaceAll('\r\n', '\\n')
            .replaceAll('\n', '\\n')
            .replaceAll('\'', '\\\''),
        params = _findArguments(content);

  @override
  String toString() {
    if (params.isEmpty)
      return content;
    else
      return '$params => $content';
  }
}

/// find arguments like $variableName in the given string
/// the $ can be escaped via \$
///
/// examples:
/// 'hello $name' => ['name']
/// 'hello \$name => []
/// 'my name is $name and I am $age years old' => ['name', 'age']
List<String> _findArguments(String content) {
  String s = content.replaceAll('\\\$', ''); // remove \$
  List<String> arguments = [];
  int indexStart = s.indexOf('\$');
  while (indexStart != -1) {
    if (indexStart == s.length - 1) break;

    int indexEnd = s.indexOf(Utils.specialRegex, indexStart + 1);
    if (indexEnd != -1) {
      arguments.add(s.substring(indexStart + 1, indexEnd));
      s = s.substring(indexEnd);
      indexStart = s.indexOf('\$');
    } else {
      arguments.add(s.substring(indexStart + 1));
      break;
    }
  }

  return arguments;
}
