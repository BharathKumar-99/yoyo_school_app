class UrlConstants {
  static const String superSpeachApi = "api.speechsuper.com";
  static const String openAiUrl =
      'https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/openai';
  static const String terms = 'https://support.yoyospeak.com/terms/';
  static const String privacy = 'https://support.yoyospeak.com/privacy/';
}

class ImageConstants {
  static const String assetsLoc = "assets/images/";
  static const String loginBg = "${assetsLoc}login_bg.png";
  static const String appLogo = "${assetsLoc}logo.png";
  static const String schoolLogo = "${assetsLoc}school_logo.png";
  static const String logoHome = "${assetsLoc}logo_home.png";
  static const String french = "${assetsLoc}french.png";
  static const String spanish = "${assetsLoc}spanish.png";
  static const String german = "${assetsLoc}german.png";
  static const String buddha = "${assetsLoc}buddha.png";
  static const String star = "${assetsLoc}star.png";
  static const String streak = "${assetsLoc}streak.png";
  static const String correct = "${assetsLoc}corect.png";
  static const String noMic = "${assetsLoc}no_mic.png";
  static const String onboarding1 = "${assetsLoc}onboarding1.png";
  static const String onboarding2 = "${assetsLoc}onboarding2.png";
  static const String onboarding3 = "${assetsLoc}onboarding3.png";
  static const String spanishWarmup = "${assetsLoc}spanish_warmup.png";
  static const String frenchWarmup = "${assetsLoc}french_warmUp.png";
  static const String germanWarmup = "${assetsLoc}german_warmup.png";
  static const String koreanWarmup = "${assetsLoc}korean_warmup.png";
  static const String russiaWarmup = "${assetsLoc}russia_warmup.png";
}

class IconConstants {
  static const String iconLoc = "assets/icons/";
  static const String emailIcon = "${iconLoc}mail.png";
  static const String vertIcon = "${iconLoc}vert-more.png";
  static const String logOutIcon = "${iconLoc}Logout.png";
  static const String lockIcon = "${iconLoc}Lock.png";
}

class AnimationAsset {
  static const String animationLoc = "assets/animation/";
  static const String streakAnimation = "${animationLoc}blazing_streak.json";
  static const String learnedSuccess = "${animationLoc}learned_success.json";
  static const String masteredSuccess = "${animationLoc}mastered_success.json";
  static const String streakTick = "${animationLoc}streak_tick.json";
  static const String yoyoWaitingText = "${animationLoc}yoyo_waiting_text.json";
}

class DbTable {
  static const String classLevel = 'class_level';
  static const String classes = 'classes';
  static const String language = 'language';
  static const String level = 'level';
  static const String phrase = 'phrase';
  static const String school = 'school';
  static const String schoolLanguage = 'school_language';
  static const String student = 'student';
  static const String teacher = 'teacher';
  static const String users = 'users';
  static const String attemptedPhrases = 'attempted_phrases';
  static const String remoteConfig = 'remote_config';
  static const String userResult = 'user_results';
  static const String streakTable = 'streak_table';
  static const String activationRequests = 'activation_requests';
  static const String phraseCategories = 'phrase_categories';
}

class Stroage {
  static const String userBucket = 'user';
}

class Constants {
  static const int minimumWordScoreleft = 45;
  static const int minimumWordScoreright = 65;
  static const int minimumSubmitScore = 80;
  static const String learned = 'Learned';
  static const String mastered = 'Mastered';

  static const int lowScreenScore = 10;

  static const int retryAttempts = 3;
}
