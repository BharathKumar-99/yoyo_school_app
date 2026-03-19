import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslateFunctions {
  TranslateFunctions._internal();

  static final TranslateFunctions _instance = TranslateFunctions._internal();

  factory TranslateFunctions() => _instance;

  TranslateLanguage selectedLanguage = TranslateLanguage.english;

  OnDeviceTranslator? _translator;
  TranslateLanguage? _lastLanguage;

  final OnDeviceTranslatorModelManager _modelManager =
      OnDeviceTranslatorModelManager();

  final Map<String, TranslateLanguage> languages = {
    "English": TranslateLanguage.english,
    "Spanish": TranslateLanguage.spanish,
    "French": TranslateLanguage.french,
    "German": TranslateLanguage.german,
    "Russian": TranslateLanguage.russian,
  };

  void updateSelectedLanguage(String language) {
    final newLang = languages[language] ?? TranslateLanguage.english;

    if (newLang != selectedLanguage) {
      selectedLanguage = newLang;

      _translator?.close();
      _translator = null;
      _lastLanguage = null;
    }
  }

  Future<void> _ensureModelDownloaded(TranslateLanguage lang) async {
    final isDownloaded = await _modelManager.isModelDownloaded(lang.bcpCode);

    if (!isDownloaded) {
      await _modelManager.downloadModel(lang.bcpCode, isWifiRequired: false);
    }
  }

  Future<void> preloadModel() async {
    await _ensureModelDownloaded(selectedLanguage);
  }

  Future<void> preloadMultiple(List<TranslateLanguage> langs) async {
    await Future.wait(langs.map((lang) => _ensureModelDownloaded(lang)));
  }

  Future<void> _initTranslatorIfNeeded() async {
    if (_translator == null || _lastLanguage != selectedLanguage) {
      _translator?.close();

      _translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: selectedLanguage,
      );

      _lastLanguage = selectedLanguage;
    }
  }

  Future<String?> translateText(String? text) async {
    if (text?.isEmpty ?? true) return null;

    if (selectedLanguage == TranslateLanguage.english) {
      return text;
    }

    await _ensureModelDownloaded(selectedLanguage);

    await _initTranslatorIfNeeded();

    return await _translator!.translateText(text!);
  }

  void dispose() {
    _translator?.close();
    _translator = null;
    _lastLanguage = null;
  }
}
