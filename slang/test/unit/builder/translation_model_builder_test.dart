import 'package:slang/builder/builder/build_model_config_builder.dart';
import 'package:slang/builder/builder/translation_model_builder.dart';
import 'package:slang/builder/model/enums.dart';
import 'package:slang/builder/model/context_type.dart';
import 'package:slang/builder/model/interface.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang/builder/model/raw_config.dart';
import 'package:test/test.dart';

void main() {
  group('TranslationModelBuilder.build', () {
    test('1 StringTextNode', () {
      final result = TranslationModelBuilder.build(
        buildConfig: RawConfig.defaultConfig.toBuildModelConfig(),
        localeDebug: RawConfig.defaultBaseLocale,
        map: {
          'test': 'a',
        },
      );
      final map = result.root.entries;
      expect((map['test'] as StringTextNode).content, 'a');
    });

    test('keyCase=snake and keyMapCase=camel', () {
      final result = TranslationModelBuilder.build(
        buildConfig: RawConfig.defaultConfig.copyWith(
          maps: ['my_map'],
          keyCase: CaseStyle.snake,
          keyMapCase: CaseStyle.camel,
        ).toBuildModelConfig(),
        localeDebug: RawConfig.defaultBaseLocale,
        map: {
          'myMap': {'my_value': 'cool'},
        },
      );
      final mapNode = result.root.entries['my_map'] as ObjectNode;
      expect((mapNode.entries['myValue'] as StringTextNode).content, 'cool');
    });

    test('keyCase=snake and keyMapCase=null', () {
      final result = TranslationModelBuilder.build(
        buildConfig: RawConfig.defaultConfig.copyWith(
          maps: ['my_map'],
          keyCase: CaseStyle.snake,
        ).toBuildModelConfig(),
        localeDebug: RawConfig.defaultBaseLocale,
        map: {
          'myMap': {'my_value 3': 'cool'},
        },
      );
      final mapNode = result.root.entries['my_map'] as ObjectNode;
      expect((mapNode.entries['my_value 3'] as StringTextNode).content, 'cool');
    });

    test('one link no parameters', () {
      final result = TranslationModelBuilder.build(
        buildConfig: RawConfig.defaultConfig.toBuildModelConfig(),
        localeDebug: RawConfig.defaultBaseLocale,
        map: {
          'a': 'A',
          'b': 'Hello @:a',
        },
      );
      final textNode = result.root.entries['b'] as StringTextNode;
      expect(textNode.params, <String>{});
      expect(textNode.content, r'Hello ${_root.a}');
    });

    test('one link 2 parameters straight', () {
      final result = TranslationModelBuilder.build(
        buildConfig: RawConfig.defaultConfig.toBuildModelConfig(),
        localeDebug: RawConfig.defaultBaseLocale,
        map: {
          'a': r'A $p1 $p1 $p2',
          'b': 'Hello @:a',
        },
      );
      final textNode = result.root.entries['b'] as StringTextNode;
      expect(textNode.params, {'p1', 'p2'});
      expect(textNode.content, r'Hello ${_root.a(p1: p1, p2: p2)}');
    });

    test('linked translations with parameters recursive', () {
      final result = TranslationModelBuilder.build(
        buildConfig: RawConfig.defaultConfig.toBuildModelConfig(),
        localeDebug: RawConfig.defaultBaseLocale,
        map: {
          'a': r'A $p1 $p1 $p2 @:b @:c',
          'b': r'Hello $p3 @:a',
          'c': r'C $p4 @:a',
        },
      );
      final textNode = result.root.entries['b'] as StringTextNode;
      expect(textNode.params, {'p1', 'p2', 'p3', 'p4'});
      expect(textNode.content,
          r'Hello ${p3} ${_root.a(p1: p1, p2: p2, p3: p3, p4: p4)}');
    });

    test('linked translation with plural', () {
      final result = TranslationModelBuilder.build(
        buildConfig: RawConfig.defaultConfig.toBuildModelConfig(),
        localeDebug: RawConfig.defaultBaseLocale,
        map: {
          'a': {
            'one': 'ONE',
            'other': r'OTHER $p1',
          },
          'b': r'Hello @:a',
        },
      );
      final textNode = result.root.entries['b'] as StringTextNode;
      expect(textNode.params, {'p1', 'n'});
      expect(textNode.paramTypeMap, {'n': 'num'});
      expect(textNode.content, r'Hello ${_root.a(p1: p1, n: n)}');
    });

    test('linked translation with context', () {
      final result = TranslationModelBuilder.build(
        buildConfig: RawConfig.defaultConfig.copyWith(contexts: [
          ContextType(
            enumName: 'GenderCon',
            enumValues: ['male', 'female'],
            paths: [],
            defaultParameter: 'gender',
            generateEnum: true,
          ),
        ]).toBuildModelConfig(),
        localeDebug: RawConfig.defaultBaseLocale,
        map: {
          'a': {
            'male': 'MALE',
            'female': r'FEMALE $p1',
          },
          'b': r'Hello @:a',
        },
      );
      final textNode = result.root.entries['b'] as StringTextNode;
      expect(textNode.params, {'p1', 'gender'});
      expect(textNode.paramTypeMap, {'gender': 'GenderCon'});
      expect(textNode.content, r'Hello ${_root.a(p1: p1, gender: gender)}');
    });

    test('empty lists should take generic type of interface', () {
      final result = TranslationModelBuilder.build(
        buildConfig: RawConfig.defaultConfig.copyWith(interfaces: [
          InterfaceConfig(
            name: 'MyInterface',
            paths: [InterfacePath('myEntry')],
            attributes: {
              InterfaceAttribute(
                attributeName: 'myList',
                returnType: 'List<MyType>',
                parameters: {},
                optional: false,
              )
            },
          ),
          InterfaceConfig(
            name: 'MyInterface2',
            paths: [InterfacePath('myEntry2.*')],
            attributes: {
              InterfaceAttribute(
                attributeName: 'myList',
                returnType: 'List<MyType2>',
                parameters: {},
                optional: false,
              )
            },
          ),
        ]).toBuildModelConfig(),
        localeDebug: RawConfig.defaultBaseLocale,
        map: {
          'myEntry': {
            'myList': [],
          },
          'myEntry2': {
            'child': {
              'myList': [],
            },
          },
        },
      );

      final objectNode = result.root.entries['myEntry'] as ObjectNode;
      expect((objectNode.entries['myList'] as ListNode).genericType, 'MyType');

      final objectNode2 = (result.root.entries['myEntry2'] as ObjectNode)
          .entries['child'] as ObjectNode;
      expect(
          (objectNode2.entries['myList'] as ListNode).genericType, 'MyType2');
    });

    test('Should not include context type if values are unspecified', () {
      final result = TranslationModelBuilder.build(
        buildConfig: RawConfig.defaultConfig.copyWith(contexts: [
          ContextType(
            enumName: 'GenderCon',
            enumValues: null,
            paths: [],
            defaultParameter: 'gender',
            generateEnum: true,
          ),
        ]).toBuildModelConfig(),
        localeDebug: RawConfig.defaultBaseLocale,
        map: {
          'a': 'b',
        },
      );

      expect(result.contexts, []);
    });
  });
}
