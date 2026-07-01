import 'package:flutter_test/flutter_test.dart';
import 'package:veriscipt_mobile/features/translator/presentation/translator_notifier.dart';

void main() {
  group('TranslatorState — default values', () {
    test('inputText is empty', () => expect(const TranslatorState().inputText, ''));
    test('sourceLang is auto', () => expect(const TranslatorState().sourceLang, 'auto'));
    test('targetLang is fr', () => expect(const TranslatorState().targetLang, 'fr'));
    test('status is idle', () => expect(const TranslatorState().translatorStatus, 'idle'));
    test('charsLimit is 5000', () => expect(const TranslatorState().charsLimit, 5000));
    test('charsUsedThisMonth is 0', () => expect(const TranslatorState().charsUsedThisMonth, 0));
    test('fromOcr is false', () => expect(const TranslatorState().fromOcr, false));
    test('fromCache is false', () => expect(const TranslatorState().fromCache, false));
  });

  group('TranslatorState.copyWith', () {
    test('updates inputText', () {
      const state = TranslatorState();
      expect(state.copyWith(inputText: 'hello').inputText, 'hello');
    });

    test('clearTranslation nulls translatedText and detectedSourceLang', () {
      const state = TranslatorState(
        translatedText: 'bonjour',
        detectedSourceLang: 'en',
      );
      final cleared = state.copyWith(clearTranslation: true);
      expect(cleared.translatedText, isNull);
      expect(cleared.detectedSourceLang, isNull);
    });

    test('clearError nulls errorMessage', () {
      const state = TranslatorState(errorMessage: 'Network error');
      expect(state.copyWith(clearError: true).errorMessage, isNull);
    });

    test('preserves unchanged fields', () {
      const state = TranslatorState(
        inputText: 'test',
        sourceLang: 'en',
        targetLang: 'de',
        charsUsedThisMonth: 250,
      );
      final updated = state.copyWith(translatorStatus: 'translating');
      expect(updated.inputText, 'test');
      expect(updated.sourceLang, 'en');
      expect(updated.targetLang, 'de');
      expect(updated.charsUsedThisMonth, 250);
    });

    test('updates charsUsedThisMonth', () {
      const state = TranslatorState(charsUsedThisMonth: 100);
      expect(state.copyWith(charsUsedThisMonth: 350).charsUsedThisMonth, 350);
    });

    test('can set fromOcr and fromCache', () {
      const state = TranslatorState();
      final updated = state.copyWith(fromOcr: true, fromCache: true);
      expect(updated.fromOcr, true);
      expect(updated.fromCache, true);
    });
  });

  group('swapLanguages — pure logic', () {
    // Mirrors the logic in TranslatorNotifier.swapLanguages()
    String resolveNewTarget(TranslatorState state) {
      return state.sourceLang == 'auto'
          ? (state.detectedSourceLang ?? 'en')
          : state.sourceLang;
    }

    test('swaps explicit source and target', () {
      const state = TranslatorState(sourceLang: 'en', targetLang: 'fr');
      expect(state.targetLang, 'fr'); // becomes new source
      expect(resolveNewTarget(state), 'en'); // old source becomes new target
    });

    test('auto source with detected lang uses detected as new target', () {
      const state = TranslatorState(
        sourceLang: 'auto',
        targetLang: 'fr',
        detectedSourceLang: 'de',
      );
      expect(resolveNewTarget(state), 'de');
    });

    test('auto source with no detected lang falls back to en', () {
      const state = TranslatorState(sourceLang: 'auto', targetLang: 'fr');
      expect(resolveNewTarget(state), 'en');
    });

    test('translatedText becomes new inputText after swap', () {
      const state = TranslatorState(
        inputText: 'hello',
        translatedText: 'bonjour',
        sourceLang: 'en',
        targetLang: 'fr',
      );
      final newInput = state.translatedText ?? state.inputText;
      expect(newInput, 'bonjour');
    });

    test('inputText preserved when no translation exists', () {
      const state = TranslatorState(inputText: 'hello', sourceLang: 'en', targetLang: 'fr');
      final newInput = state.translatedText ?? state.inputText;
      expect(newInput, 'hello');
    });
  });

  group('quota check logic', () {
    test('5000 chars limit: used=4000, text=999 → allowed', () {
      const charsUsed = 4000;
      const textLength = 999;
      expect(charsUsed + textLength <= 5000, isTrue);
    });

    test('5000 chars limit: used=4500, text=600 → denied', () {
      const charsUsed = 4500;
      const textLength = 600;
      expect(charsUsed + textLength <= 5000, isFalse);
    });

    test('exactly at limit is allowed', () {
      const charsUsed = 4000;
      const textLength = 1000;
      expect(charsUsed + textLength <= 5000, isTrue);
    });
  });
}
