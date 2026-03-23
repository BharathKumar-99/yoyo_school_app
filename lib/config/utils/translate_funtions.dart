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
    "Afrikaans": TranslateLanguage.afrikaans,
    "Albanian": TranslateLanguage.albanian,
    "Arabic": TranslateLanguage.arabic,
    "Belarusian": TranslateLanguage.belarusian,
    "Bengali": TranslateLanguage.bengali,
    "Bulgarian": TranslateLanguage.bulgarian,
    "Catalan": TranslateLanguage.catalan,
    "Chinese (Simplified)": TranslateLanguage.chinese,
    "Chinese (Traditional)": TranslateLanguage.chinese,
    "Croatian": TranslateLanguage.croatian,
    "Czech": TranslateLanguage.czech,
    "Danish": TranslateLanguage.danish,
    "Dutch": TranslateLanguage.dutch,
    "English": TranslateLanguage.english,
    "Esperanto": TranslateLanguage.esperanto,
    "Estonian": TranslateLanguage.estonian,
    "Finnish": TranslateLanguage.finnish,
    "French": TranslateLanguage.french,
    "Galician": TranslateLanguage.galician,
    "Georgian": TranslateLanguage.georgian,
    "German": TranslateLanguage.german,
    "Greek": TranslateLanguage.greek,
    "Gujarati": TranslateLanguage.gujarati,
    "Haitian Creole": TranslateLanguage.haitian,
    "Hebrew": TranslateLanguage.hebrew,
    "Hindi": TranslateLanguage.hindi,
    "Hungarian": TranslateLanguage.hungarian,
    "Icelandic": TranslateLanguage.icelandic,
    "Indonesian": TranslateLanguage.indonesian,
    "Irish": TranslateLanguage.irish,
    "Italian": TranslateLanguage.italian,
    "Japanese": TranslateLanguage.japanese,
    "Kannada": TranslateLanguage.kannada,
    "Korean": TranslateLanguage.korean,
    "Latvian": TranslateLanguage.latvian,
    "Lithuanian": TranslateLanguage.lithuanian,
    "Macedonian": TranslateLanguage.macedonian,
    "Malay": TranslateLanguage.malay,
    "Maltese": TranslateLanguage.maltese,
    "Marathi": TranslateLanguage.marathi,
    "Norwegian": TranslateLanguage.norwegian,
    "Persian": TranslateLanguage.persian,
    "Polish": TranslateLanguage.polish,
    "Portuguese": TranslateLanguage.portuguese,
    "Romanian": TranslateLanguage.romanian,
    "Russian": TranslateLanguage.russian,
    "Slovak": TranslateLanguage.slovak,
    "Slovenian": TranslateLanguage.slovenian,
    "Spanish": TranslateLanguage.spanish,
    "Swahili": TranslateLanguage.swahili,
    "Swedish": TranslateLanguage.swedish,
    "Tagalog (Filipino)": TranslateLanguage.tagalog,
    "Tamil": TranslateLanguage.tamil,
    "Telugu": TranslateLanguage.telugu,
    "Thai": TranslateLanguage.thai,
    "Turkish": TranslateLanguage.turkish,
    "Ukrainian": TranslateLanguage.ukrainian,
    "Urdu": TranslateLanguage.urdu,
    "Vietnamese": TranslateLanguage.vietnamese,
    "Welsh": TranslateLanguage.welsh,
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
