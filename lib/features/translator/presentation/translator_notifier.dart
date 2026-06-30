import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../home/data/quota_repository.dart';
import '../data/translation_repository.dart';

final translatorNotifierProvider =
    NotifierProvider<TranslatorNotifier, TranslatorState>(TranslatorNotifier.new);

class TranslatorState {
  const TranslatorState({
    this.inputText = '',
    this.sourceLang = 'auto',
    this.targetLang = 'fr',
    this.translatorStatus = 'idle',
    this.translatedText,
    this.detectedSourceLang,
    this.charsUsedThisMonth = 0,
    this.charsLimit = 5000,
    this.errorMessage,
    this.fromOcr = false,
    this.fromCache = false,
  });

  final String inputText;
  final String sourceLang;
  final String targetLang;
  final String translatorStatus;
  final String? translatedText;
  final String? detectedSourceLang;
  final int charsUsedThisMonth;
  final int charsLimit;
  final String? errorMessage;
  final bool fromOcr;
  final bool fromCache;

  TranslatorState copyWith({
    String? inputText,
    String? sourceLang,
    String? targetLang,
    String? translatorStatus,
    String? translatedText,
    String? detectedSourceLang,
    int? charsUsedThisMonth,
    int? charsLimit,
    String? errorMessage,
    bool? fromOcr,
    bool? fromCache,
    bool clearTranslation = false,
    bool clearError = false,
  }) {
    return TranslatorState(
      inputText: inputText ?? this.inputText,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      translatorStatus: translatorStatus ?? this.translatorStatus,
      translatedText: clearTranslation ? null : translatedText ?? this.translatedText,
      detectedSourceLang: clearTranslation ? null : detectedSourceLang ?? this.detectedSourceLang,
      charsUsedThisMonth: charsUsedThisMonth ?? this.charsUsedThisMonth,
      charsLimit: charsLimit ?? this.charsLimit,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      fromOcr: fromOcr ?? this.fromOcr,
      fromCache: fromCache ?? this.fromCache,
    );
  }
}

class TranslatorNotifier extends Notifier<TranslatorState> {
  Timer? _debounce;

  @override
  TranslatorState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const TranslatorState();
  }

  void initWithText(String text) {
    state = state.copyWith(inputText: text, fromOcr: true, clearTranslation: true);
    _scheduleTanslate();
  }

  void setInputText(String text) {
    state = state.copyWith(inputText: text, clearTranslation: true);
    _scheduleTanslate();
  }

  void _scheduleTanslate() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (state.inputText.trim().isNotEmpty) {
        translate();
      }
    });
  }

  void setSourceLang(String lang) {
    state = state.copyWith(sourceLang: lang, clearTranslation: true);
  }

  void setTargetLang(String lang) {
    state = state.copyWith(targetLang: lang, clearTranslation: true);
    if (state.inputText.trim().isNotEmpty) translate();
  }

  void swapLanguages() {
    final newSource = state.targetLang;
    final newTarget = state.sourceLang == 'auto'
        ? (state.detectedSourceLang ?? 'en')
        : state.sourceLang;
    final newInput = state.translatedText ?? state.inputText;
    state = state.copyWith(
      sourceLang: newSource,
      targetLang: newTarget,
      inputText: newInput,
      clearTranslation: true,
    );
    if (newInput.trim().isNotEmpty) translate();
  }

  Future<void> translate() async {
    final text = state.inputText.trim();
    if (text.isEmpty) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final repo = ref.read(translationRepositoryProvider);

    final canTranslate = await repo.canTranslate(userId, text.length);
    if (!canTranslate) {
      state = state.copyWith(translatorStatus: 'quota_exceeded');
      return;
    }

    state = state.copyWith(translatorStatus: 'translating', clearError: true);

    try {
      final result = await repo.translateText(
        text: text,
        sourceLang: state.sourceLang,
        targetLang: state.targetLang,
        userId: userId,
      );

      state = state.copyWith(
        translatorStatus: 'done',
        translatedText: result.translatedText,
        detectedSourceLang: result.detectedSourceLang,
        fromCache: result.fromCache,
      );

      // Refresh quota if it wasn't from cache
      if (!result.fromCache) {
        ref.invalidate(quotaProvider);
      }
    } catch (e) {
      state = state.copyWith(translatorStatus: 'failed', errorMessage: e.toString());
    }
  }

  Future<void> copyTranslation() async {
    final text = state.translatedText;
    if (text != null) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  void clearInput() {
    _debounce?.cancel();
    state = const TranslatorState();
  }
}
