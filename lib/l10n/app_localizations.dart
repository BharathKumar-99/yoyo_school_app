import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @login_text.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_text;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @send_otp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get send_otp;

  /// No description provided for @your_profile.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get your_profile;

  /// No description provided for @your_metrics.
  ///
  /// In en, this message translates to:
  /// **'Your metrics'**
  String get your_metrics;

  /// No description provided for @phrases.
  ///
  /// In en, this message translates to:
  /// **'Phrases'**
  String get phrases;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'< Back'**
  String get back;

  /// No description provided for @vocab.
  ///
  /// In en, this message translates to:
  /// **'Vocab'**
  String get vocab;

  /// No description provided for @effort.
  ///
  /// In en, this message translates to:
  /// **'Effort'**
  String get effort;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @your_classes.
  ///
  /// In en, this message translates to:
  /// **'Your classes'**
  String get your_classes;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recording;

  /// No description provided for @submit_score.
  ///
  /// In en, this message translates to:
  /// **'Submit Score'**
  String get submit_score;

  /// No description provided for @profile_header.
  ///
  /// In en, this message translates to:
  /// **'This is your profile information which is not shared or editale.'**
  String get profile_header;

  /// No description provided for @verify_otp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verify_otp;

  /// No description provided for @otp_header.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit code sent to'**
  String get otp_header;

  /// No description provided for @resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resend_otp;

  /// No description provided for @otp_expired.
  ///
  /// In en, this message translates to:
  /// **'OTP Expiried or Invalid'**
  String get otp_expired;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level: '**
  String get level;

  /// No description provided for @learned.
  ///
  /// In en, this message translates to:
  /// **'Learned'**
  String get learned;

  /// No description provided for @mastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get mastered;

  /// No description provided for @classText.
  ///
  /// In en, this message translates to:
  /// **'Class:'**
  String get classText;

  /// No description provided for @empty_list.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show'**
  String get empty_list;

  /// No description provided for @holdAndRecord.
  ///
  /// In en, this message translates to:
  /// **'Hold & Speak'**
  String get holdAndRecord;

  /// No description provided for @learnIt.
  ///
  /// In en, this message translates to:
  /// **'Learn It'**
  String get learnIt;

  /// No description provided for @masterIt.
  ///
  /// In en, this message translates to:
  /// **'Master It'**
  String get masterIt;

  /// No description provided for @goOnAStreak.
  ///
  /// In en, this message translates to:
  /// **'Go on a Streak'**
  String get goOnAStreak;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @youareJust.
  ///
  /// In en, this message translates to:
  /// **'You were just'**
  String get youareJust;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get off;

  /// No description provided for @canYouMasterIT.
  ///
  /// In en, this message translates to:
  /// **'Can you Master it?'**
  String get canYouMasterIT;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You:'**
  String get you;

  /// No description provided for @newText.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newText;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @learnAgain.
  ///
  /// In en, this message translates to:
  /// **'Learn Again'**
  String get learnAgain;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takeAPhoto;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recorded;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get somethingWentWrong;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated'**
  String get profileUpdated;

  /// No description provided for @readAndpractise.
  ///
  /// In en, this message translates to:
  /// **'Read & Practise'**
  String get readAndpractise;

  /// No description provided for @rememberAndPractise.
  ///
  /// In en, this message translates to:
  /// **'Remember & Practise'**
  String get rememberAndPractise;

  /// No description provided for @notAttemptText.
  ///
  /// In en, this message translates to:
  /// **'Nice Try!'**
  String get notAttemptText;

  /// No description provided for @improvedBy.
  ///
  /// In en, this message translates to:
  /// **'Wow, you improved by +'**
  String get improvedBy;

  /// No description provided for @noImporove.
  ///
  /// In en, this message translates to:
  /// **'Oh no, you didn\'t improve'**
  String get noImporove;

  /// No description provided for @tryThisPhrase.
  ///
  /// In en, this message translates to:
  /// **'Try this Phrase'**
  String get tryThisPhrase;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get checking;

  /// No description provided for @niceWork.
  ///
  /// In en, this message translates to:
  /// **'Nice work!'**
  String get niceWork;

  /// No description provided for @ohNoNotThis.
  ///
  /// In en, this message translates to:
  /// **'Oh no, not this time..'**
  String get ohNoNotThis;

  /// No description provided for @yourStreakWas.
  ///
  /// In en, this message translates to:
  /// **'Your streak was'**
  String get yourStreakWas;

  /// No description provided for @tryToMaster.
  ///
  /// In en, this message translates to:
  /// **'Try to Master >'**
  String get tryToMaster;

  /// No description provided for @friendly_90_100_title.
  ///
  /// In en, this message translates to:
  /// **'Fantastic!'**
  String get friendly_90_100_title;

  /// No description provided for @friendly_90_100_feedback.
  ///
  /// In en, this message translates to:
  /// **'You sound like a native speaker — keep it up!'**
  String get friendly_90_100_feedback;

  /// No description provided for @friendly_90_100_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Record again and notice how natural it feels.'**
  String get friendly_90_100_microDrill;

  /// No description provided for @friendly_80_89_title.
  ///
  /// In en, this message translates to:
  /// **'Really clear pronunciation!'**
  String get friendly_80_89_title;

  /// No description provided for @friendly_80_89_feedback.
  ///
  /// In en, this message translates to:
  /// **'Just smooth out your rhythm a little.'**
  String get friendly_80_89_feedback;

  /// No description provided for @friendly_80_89_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Say it once slowly, once fast, keeping it clear.'**
  String get friendly_80_89_microDrill;

  /// No description provided for @friendly_70_79_title.
  ///
  /// In en, this message translates to:
  /// **'Good work!'**
  String get friendly_70_79_title;

  /// No description provided for @friendly_70_79_feedback.
  ///
  /// In en, this message translates to:
  /// **'Focus on linking words more naturally.'**
  String get friendly_70_79_feedback;

  /// No description provided for @friendly_70_79_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Repeat twice, connecting every word in one breath.'**
  String get friendly_70_79_microDrill;

  /// No description provided for @friendly_60_69_title.
  ///
  /// In en, this message translates to:
  /// **'Nice effort!'**
  String get friendly_60_69_title;

  /// No description provided for @friendly_60_69_feedback.
  ///
  /// In en, this message translates to:
  /// **'Try slowing down and opening your vowels.'**
  String get friendly_60_69_feedback;

  /// No description provided for @friendly_60_69_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Clap once per syllable, then say it smoothly.'**
  String get friendly_60_69_microDrill;

  /// No description provided for @friendly_0_59_title.
  ///
  /// In en, this message translates to:
  /// **'Almost there!'**
  String get friendly_0_59_title;

  /// No description provided for @friendly_0_59_feedback.
  ///
  /// In en, this message translates to:
  /// **'Try again, listening carefully to each word.'**
  String get friendly_0_59_feedback;

  /// No description provided for @friendly_0_59_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Echo the model phrase three times.'**
  String get friendly_0_59_microDrill;

  /// No description provided for @exam_90_100_title.
  ///
  /// In en, this message translates to:
  /// **'Excellent accuracy!'**
  String get exam_90_100_title;

  /// No description provided for @exam_90_100_feedback.
  ///
  /// In en, this message translates to:
  /// **'That would earn full marks in an exam.'**
  String get exam_90_100_feedback;

  /// No description provided for @exam_90_100_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Repeat once more to confirm consistency.'**
  String get exam_90_100_microDrill;

  /// No description provided for @exam_80_89_title.
  ///
  /// In en, this message translates to:
  /// **'Strong pronunciation!'**
  String get exam_80_89_title;

  /// No description provided for @exam_80_89_feedback.
  ///
  /// In en, this message translates to:
  /// **'Refine intonation for a natural exam tone.'**
  String get exam_80_89_feedback;

  /// No description provided for @exam_80_89_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Shadow a native recording focusing on stress.'**
  String get exam_80_89_microDrill;

  /// No description provided for @exam_70_79_title.
  ///
  /// In en, this message translates to:
  /// **'Clear and intelligible!'**
  String get exam_70_79_title;

  /// No description provided for @exam_70_79_feedback.
  ///
  /// In en, this message translates to:
  /// **'Improve stress on key syllables.'**
  String get exam_70_79_feedback;

  /// No description provided for @exam_70_79_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Underline stressed syllables and repeat twice.'**
  String get exam_70_79_microDrill;

  /// No description provided for @exam_60_69_title.
  ///
  /// In en, this message translates to:
  /// **'Understandable!'**
  String get exam_60_69_title;

  /// No description provided for @exam_60_69_feedback.
  ///
  /// In en, this message translates to:
  /// **'Needs clearer vowel sounds.'**
  String get exam_60_69_feedback;

  /// No description provided for @exam_60_69_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Record again, exaggerating vowel length slightly.'**
  String get exam_60_69_microDrill;

  /// No description provided for @exam_0_59_title.
  ///
  /// In en, this message translates to:
  /// **'Reattempt needed!'**
  String get exam_0_59_title;

  /// No description provided for @exam_0_59_feedback.
  ///
  /// In en, this message translates to:
  /// **'Focus on saying each word distinctly.'**
  String get exam_0_59_feedback;

  /// No description provided for @exam_0_59_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Pause after each word, then blend together.'**
  String get exam_0_59_microDrill;

  /// No description provided for @challenge_90_100_title.
  ///
  /// In en, this message translates to:
  /// **'Outstanding!'**
  String get challenge_90_100_title;

  /// No description provided for @challenge_90_100_feedback.
  ///
  /// In en, this message translates to:
  /// **'You’ve mastered it — can you beat your time?'**
  String get challenge_90_100_feedback;

  /// No description provided for @challenge_90_100_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Say it faster with perfect clarity.'**
  String get challenge_90_100_microDrill;

  /// No description provided for @challenge_80_89_title.
  ///
  /// In en, this message translates to:
  /// **'Strong score!'**
  String get challenge_80_89_title;

  /// No description provided for @challenge_80_89_feedback.
  ///
  /// In en, this message translates to:
  /// **'Aim for 90+ next try!'**
  String get challenge_80_89_feedback;

  /// No description provided for @challenge_80_89_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Record again, keeping rhythm tight and fluent.'**
  String get challenge_80_89_microDrill;

  /// No description provided for @challenge_70_79_title.
  ///
  /// In en, this message translates to:
  /// **'You’re close to pro level!'**
  String get challenge_70_79_title;

  /// No description provided for @challenge_70_79_feedback.
  ///
  /// In en, this message translates to:
  /// **'Sharpen the stress on tough words.'**
  String get challenge_70_79_feedback;

  /// No description provided for @challenge_70_79_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Repeat until it sounds effortless twice in a row.'**
  String get challenge_70_79_microDrill;

  /// No description provided for @challenge_60_69_title.
  ///
  /// In en, this message translates to:
  /// **'You’re improving !'**
  String get challenge_60_69_title;

  /// No description provided for @challenge_60_69_feedback.
  ///
  /// In en, this message translates to:
  /// **'Precision beats speed — aim for 70+.'**
  String get challenge_60_69_feedback;

  /// No description provided for @challenge_60_69_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Focus on tricky word endings and retry.'**
  String get challenge_60_69_microDrill;

  /// No description provided for @challenge_0_59_title.
  ///
  /// In en, this message translates to:
  /// **'Tough one!'**
  String get challenge_0_59_title;

  /// No description provided for @challenge_0_59_feedback.
  ///
  /// In en, this message translates to:
  /// **'Let’s go again — you can beat this.'**
  String get challenge_0_59_feedback;

  /// No description provided for @challenge_0_59_microDrill.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing until you feel confident.'**
  String get challenge_0_59_microDrill;

  /// No description provided for @especially_in.
  ///
  /// In en, this message translates to:
  /// **'especially in'**
  String get especially_in;

  /// No description provided for @repeat_slowly.
  ///
  /// In en, this message translates to:
  /// **'Repeat slowly:'**
  String get repeat_slowly;

  /// No description provided for @enableStreak.
  ///
  /// In en, this message translates to:
  /// **'Enable Streak'**
  String get enableStreak;

  /// No description provided for @frenchSlack.
  ///
  /// In en, this message translates to:
  /// **'French Slack'**
  String get frenchSlack;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @you_did_it.
  ///
  /// In en, this message translates to:
  /// **'you did it!'**
  String get you_did_it;

  /// No description provided for @learnedPhrase.
  ///
  /// In en, this message translates to:
  /// **'you have learned this phrase, now can you master it ?'**
  String get learnedPhrase;

  /// No description provided for @withAScoreOf.
  ///
  /// In en, this message translates to:
  /// **'With a score of'**
  String get withAScoreOf;

  /// No description provided for @youRocked.
  ///
  /// In en, this message translates to:
  /// **'you really rocked this one!'**
  String get youRocked;

  /// No description provided for @wow.
  ///
  /// In en, this message translates to:
  /// **'Wow!'**
  String get wow;

  /// No description provided for @masteredIt.
  ///
  /// In en, this message translates to:
  /// **'You Mastered it!'**
  String get masteredIt;

  /// No description provided for @your_score.
  ///
  /// In en, this message translates to:
  /// **'Your score was'**
  String get your_score;

  /// No description provided for @master_more.
  ///
  /// In en, this message translates to:
  /// **'Master more phrases and you will get your Alicante Badge! '**
  String get master_more;

  /// No description provided for @next_phrase.
  ///
  /// In en, this message translates to:
  /// **'Next Phrase..'**
  String get next_phrase;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @lastLearned.
  ///
  /// In en, this message translates to:
  /// **'You\'ve finished learning this language!'**
  String get lastLearned;

  /// No description provided for @lastMastered.
  ///
  /// In en, this message translates to:
  /// **'You\'ve mastered all phrases in this language!'**
  String get lastMastered;

  /// No description provided for @whoops.
  ///
  /// In en, this message translates to:
  /// **'Whoops!'**
  String get whoops;

  /// No description provided for @itseemslikesomethingwentwrong.
  ///
  /// In en, this message translates to:
  /// **'It seems like something went wrong with the recording'**
  String get itseemslikesomethingwentwrong;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @noBgNoise.
  ///
  /// In en, this message translates to:
  /// **'There is no background noise'**
  String get noBgNoise;

  /// No description provided for @holdingRec.
  ///
  /// In en, this message translates to:
  /// **'You\'re holding the record button for the duration of your phrase'**
  String get holdingRec;

  /// No description provided for @micPermission.
  ///
  /// In en, this message translates to:
  /// **'The app has permission to use your microphone'**
  String get micPermission;

  /// No description provided for @checkMark.
  ///
  /// In en, this message translates to:
  /// **'✔️'**
  String get checkMark;

  /// No description provided for @threeTryNext.
  ///
  /// In en, this message translates to:
  /// **'Three tries done — maybe take a break with another phrase?'**
  String get threeTryNext;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Find a quiet spot'**
  String get onboarding1Title;

  /// No description provided for @onBoarding1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Yoyo works best with no background noise'**
  String get onBoarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Grab your headphones & microphone'**
  String get onboarding2Title;

  /// No description provided for @onBoarding2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The clearer you hear and speak, the better the result'**
  String get onBoarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Don’t despair'**
  String get onboarding3Title;

  /// No description provided for @onBoarding3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Even AI can get it wrong sometimes. Keep going!'**
  String get onBoarding3Subtitle;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go!'**
  String get letsGo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
