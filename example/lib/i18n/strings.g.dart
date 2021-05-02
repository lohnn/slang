
/*
 * Generated file. Do not edit.
 * 
 * Locales: 2
 * Strings: 12 (6.0 per locale)
 * 
 * Built on 2021-05-02 at 21:08 UTC
 */

import 'package:flutter/widgets.dart';

const AppLocale _baseLocale = AppLocale.en;
AppLocale _currLocale = _baseLocale;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en)
/// - if (LocaleSettings.currentLocale == AppLocale.en)
enum AppLocale {
	en, // 'en' (base locale, fallback)
	de, // 'de'
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
///
/// Usage:
/// String translated = t.someKey.anotherKey;
_StringsEn _t = _currLocale.translations;
_StringsEn get t => _t;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // get t variable
/// String translated = t.someKey.anotherKey; // use t variable
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw('Please wrap your app with "TranslationProvider".');
		}
		return inheritedWidget.translations;
	}
}

class LocaleSettings {
	LocaleSettings._(); // no constructor

	/// Uses locale of the device, fallbacks to base locale.
	/// Returns the locale which has been set.
	/// Hint for pre 4.x.x developers: You can access the raw string via LocaleSettings.useDeviceLocale().languageTag
	static AppLocale useDeviceLocale() {
		String? deviceLocale = WidgetsBinding.instance?.window.locale.toLanguageTag();
		if (deviceLocale != null)
			return setLocaleRaw(deviceLocale);
		else
			return setLocale(_baseLocale);
	}

	/// Sets locale
	/// Returns the locale which has been set.
	static AppLocale setLocale(AppLocale locale) {
		_currLocale = locale;
		_t = _currLocale.translations;

		final state = _translationProviderKey.currentState;
		if (state != null) {
			// force rebuild if TranslationProvider is used
			state.setLocale(_currLocale);
		}

		return _currLocale;
	}

	/// Sets locale using string tag (e.g. en_US, de-DE, fr)
	/// Fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale setLocaleRaw(String localeRaw) {
		final selected = _selectLocale(localeRaw);
		return setLocale(selected ?? _baseLocale);
	}

	/// Gets current locale.
	/// Hint for pre 4.x.x developers: You can access the raw string via LocaleSettings.currentLocale.languageTag
	static AppLocale get currentLocale {
		return _currLocale;
	}

	/// Gets base locale.
	/// Hint for pre 4.x.x developers: You can access the raw string via LocaleSettings.baseLocale.languageTag
	static AppLocale get baseLocale {
		return _baseLocale;
	}

	/// Gets supported locales in string format.
	static List<String> get supportedLocalesRaw {
		return AppLocale.values
			.map((locale) => locale.languageTag)
			.toList();
	}

	/// Gets supported locales (as Locale objects) with base locale sorted first.
	static List<Locale> get supportedLocales {
		return AppLocale.values
			.map((locale) => locale.flutterLocale)
			.toList();
	}

	/// Sets plural resolver for languages which are not yet supported by library
	/// See https://unicode-org.github.io/cldr-staging/charts/latest/supplemental/language_plural_rules.html
	/// See https://github.com/Tienisto/flutter-fast-i18n/blob/master/lib/src/model/pluralization_resolvers.dart
	/// Only language part matters, script and country parts are ignored
	static final _renderedResolvers = ['de','en',];
	static void setPluralResolver({required String language, required PluralResolver cardinalResolver, required PluralResolver ordinalResolver}) {
		if (_renderedResolvers.contains(language)) {
			print('Hint: You are overwriting the preconfigured plural resolver for <lang = $language>');
		}
		_pluralResolversCardinal[language] = cardinalResolver;
		_pluralResolversOrdinal[language] = ordinalResolver;
	}

}

// extensions for AppLocale

extension AppLocaleExtensions on AppLocale {
	_StringsEn get translations {
		switch (this) {
			case AppLocale.en: return _StringsEn._instance;
			case AppLocale.de: return _StringsDe._instance;
		}
	}

	String get languageTag {
		switch (this) {
			case AppLocale.en: return 'en';
			case AppLocale.de: return 'de';
		}
	}

	Locale get flutterLocale {
		switch (this) {
			case AppLocale.en: return Locale.fromSubtags(languageCode: 'en');
			case AppLocale.de: return Locale.fromSubtags(languageCode: 'de');
		}
	}
}

extension StringAppLocaleExtensions on String {
	AppLocale? toAppLocale() {
		switch (this) {
			case 'en': return AppLocale.en;
			case 'de': return AppLocale.de;
			default: return null;
		}
	}
}

// wrappers

GlobalKey<_TranslationProviderState> _translationProviderKey = new GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
	TranslationProvider({required this.child}) : super(key: _translationProviderKey);

	final Widget child;

	@override
	_TranslationProviderState createState() => _TranslationProviderState();
}

class _TranslationProviderState extends State<TranslationProvider> {
	AppLocale locale = _currLocale;

	void setLocale(AppLocale newLocale) {
		setState(() {
			locale = newLocale;
		});
	}

	@override
	Widget build(BuildContext context) {
		return _InheritedLocaleData(
			locale: locale,
			child: widget.child,
		);
	}
}

class _InheritedLocaleData extends InheritedWidget {
	final AppLocale locale;
	final _StringsEn translations; // store translations to avoid switch call
	_InheritedLocaleData({required this.locale, required Widget child})
		: translations = locale.translations, super(child: child);

	@override
	bool updateShouldNotify(_InheritedLocaleData oldWidget) {
		return oldWidget.locale != locale;
	}
}

// pluralization resolvers

// for unsupported languages
// map: language -> resolver
typedef String PluralResolver(num n, {String? zero, String? one, String? two, String? few, String? many, String? other});
Map<String, PluralResolver> _pluralResolversCardinal = {};
Map<String, PluralResolver> _pluralResolversOrdinal = {};

PluralResolver _missingPluralResolver(String language) {
	throw('Resolver for <lang = $language> not specified');
}

// prepared by fast_i18n

String _pluralCardinalDe(num n, {String? zero, String? one, String? two, String? few, String? many, String? other}) {
	if (n == 1)
		return one!;
	return other!;
}

String _pluralOrdinalDe(num n, {String? zero, String? one, String? two, String? few, String? many, String? other}) {
	return other!;
}

String _pluralCardinalEn(num n, {String? zero, String? one, String? two, String? few, String? many, String? other}) {
	if (n == 1)
		return one!;
	return other!;
}

String _pluralOrdinalEn(num n, {String? zero, String? one, String? two, String? few, String? many, String? other}) {
	if (n % 10 == 1 && n % 100 != 11)
		return one!;
	if (n % 10 == 2 && n % 100 != 12)
		return two!;
	if (n % 10 == 3 && n % 100 != 13)
		return few!;
	return other!;
}

// helpers

final _localeRegex = RegExp(r'^([A-Za-z]{2,4})([_-]([A-Za-z]{4}))?([_-]([A-Za-z]{2}|[0-9]{3}))?$');
AppLocale? _selectLocale(String localeRaw) {
	final match = _localeRegex.firstMatch(localeRaw);
	AppLocale? selected;
	if (match != null) {
		final language = match.group(1);

		// match exactly
		selected = AppLocale.values
			.cast<AppLocale?>()
			.firstWhere((supported) => supported?.languageTag == localeRaw.replaceAll('_', '-'), orElse: () => null);

		if (selected == null && language != null) {
			// match language
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.startsWith(language) == true, orElse: () => null);
		}
	}
	return selected;
}

// translations

class _StringsEn {
	_StringsEn._(); // no constructor

	static _StringsEn _instance = _StringsEn._();

	_StringsMainScreenEn get mainScreen => _StringsMainScreenEn._instance;
	Map<String, String> get locales => {
		'en': 'English',
		'de': 'German',
	};
}

class _StringsMainScreenEn {
	_StringsMainScreenEn._(); // no constructor

	static _StringsMainScreenEn _instance = _StringsMainScreenEn._();

	String get title => 'An English Title';
	String counter({required num count}) => (_pluralResolversCardinal['en'] ?? _pluralCardinalEn)(count,
		one: 'You pressed $count time.',
		other: 'You pressed $count times.',
	);
	String get tapMe => 'Tap me';
}

class _StringsDe implements _StringsEn {
	_StringsDe._(); // no constructor

	static _StringsDe _instance = _StringsDe._();

	@override _StringsMainScreenDe get mainScreen => _StringsMainScreenDe._instance;
	@override Map<String, String> get locales => {
		'en': 'Englisch',
		'de': 'Deutsch',
	};
}

class _StringsMainScreenDe implements _StringsMainScreenEn {
	_StringsMainScreenDe._(); // no constructor

	static _StringsMainScreenDe _instance = _StringsMainScreenDe._();

	@override String get title => 'Ein deutscher Titel';
	@override String counter({required num count}) => (_pluralResolversCardinal['de'] ?? _pluralCardinalDe)(count,
		one: 'Du hast einmal gedrückt.',
		other: 'Du hast $count mal gedrückt.',
	);
	@override String get tapMe => 'Drück mich';
}
