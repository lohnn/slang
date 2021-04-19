/// general config, applies to all locales
class I18nConfig {
  final String baseName; // name of all i18n files, like strings or messages
  final String baseLocale; // defaults to 'en'
  final List<String> maps; // list of entities treated as maps and not classes
  final KeyCase? keyCase;
  final String translateVariable;
  final String enumName;
  final TranslationClassVisibility translationClassVisibility;

  I18nConfig(
      {required this.baseName,
      required this.baseLocale,
      required this.maps,
      required this.keyCase,
      required this.translateVariable,
      required this.enumName,
      required this.translationClassVisibility});

  @override
  String toString() => '$baseLocale, maps: $maps';
}

enum TranslationClassVisibility { private, public }
enum KeyCase { camel, pascal, snake }

extension Parser on String? {
  KeyCase? toKeyCase() {
    switch (this) {
      case 'camel':
        return KeyCase.camel;
      case 'snake':
        return KeyCase.snake;
      case 'pascal':
        return KeyCase.pascal;
      default:
        return null;
    }
  }

  TranslationClassVisibility? toTranslationClassVisibility() {
    switch (this) {
      case 'private':
        return TranslationClassVisibility.private;
      case 'public':
        return TranslationClassVisibility.public;
      default:
        return null;
    }
  }
}
