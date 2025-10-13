class UrlConstants {
  static const String superSpeachApi = "api.speechsuper.com";
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
}

class IconConstants {
  static const String iconLoc = "assets/icons/";
  static const String emailIcon = "${iconLoc}mail.png";
  static const String vertIcon = "${iconLoc}vert-more.png";
  static const String logOutIcon = "${iconLoc}Logout.png";
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
}

class Stroage {
  static const String userBucket = 'user';
}

class Constants {
  static const int minimumWordScore = 50;
  static const int minimumSubmitScore = 75;
}
