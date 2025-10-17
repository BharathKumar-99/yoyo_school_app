import '../router/navigation_helper.dart';

enum ModeType { friendly, examPrep, challenge }

class FeedbackResult {
  final String title;
  final String feedback;
  final String microDrill;

  FeedbackResult({
    required this.title,
    required this.feedback,
    required this.microDrill,
  });
}

class ScoreFeedback {
  static FeedbackResult getFeedback({
    required ModeType mode,
    required int score,
  }) {
    if (score < 0 || score > 100) {
      throw ArgumentError('Score must be between 0 and 100');
    }

    switch (mode) {
      case ModeType.friendly:
        return _friendlyFeedback(score);
      case ModeType.examPrep:
        return _examPrepFeedback(score);
      case ModeType.challenge:
        return _challengeFeedback(score);
    }
  }

  // 🟢 Friendly Mode
  static FeedbackResult _friendlyFeedback(int score) {
    if (score >= 90) {
      return FeedbackResult(
        title: text.friendly_90_100_title,
        feedback: text.friendly_90_100_feedback,
        microDrill: text.friendly_90_100_microDrill,
      );
    } else if (score >= 80) {
      return FeedbackResult(
        title: text.friendly_80_89_title,
        feedback: text.friendly_80_89_feedback,
        microDrill: text.friendly_80_89_microDrill,
      );
    } else if (score >= 70) {
      return FeedbackResult(
        title: text.friendly_70_79_title,
        feedback: text.friendly_70_79_feedback,
        microDrill: text.friendly_70_79_microDrill,
      );
    } else if (score >= 60) {
      return FeedbackResult(
        title: text.friendly_60_69_title,
        feedback: text.friendly_60_69_feedback,
        microDrill: text.friendly_60_69_microDrill,
      );
    } else {
      return FeedbackResult(
        title: text.friendly_0_59_title,
        feedback: text.friendly_0_59_feedback,
        microDrill: text.friendly_0_59_microDrill,
      );
    }
  }

  // 🧮 Exam-Prep Mode
  static FeedbackResult _examPrepFeedback(int score) {
    if (score >= 90) {
      return FeedbackResult(
        title: text.exam_90_100_title,
        feedback: text.exam_90_100_feedback,
        microDrill: text.exam_90_100_microDrill,
      );
    } else if (score >= 80) {
      return FeedbackResult(
        title: text.exam_80_89_title,
        feedback: text.exam_80_89_feedback,
        microDrill: text.exam_80_89_microDrill,
      );
    } else if (score >= 70) {
      return FeedbackResult(
        title: text.exam_70_79_title,
        feedback: text.exam_70_79_feedback,
        microDrill: text.exam_70_79_microDrill,
      );
    } else if (score >= 60) {
      return FeedbackResult(
        title: text.exam_60_69_title,
        feedback: text.exam_60_69_feedback,
        microDrill: text.exam_60_69_microDrill,
      );
    } else {
      return FeedbackResult(
        title: text.exam_0_59_title,
        feedback: text.exam_0_59_feedback,
        microDrill: text.exam_0_59_microDrill,
      );
    }
  }

  // 🔥 Challenge Mode
  static FeedbackResult _challengeFeedback(int score) {
    if (score >= 90) {
      return FeedbackResult(
        title: text.challenge_90_100_title,
        feedback: text.challenge_90_100_feedback,
        microDrill: text.challenge_90_100_microDrill,
      );
    } else if (score >= 80) {
      return FeedbackResult(
        title: text.challenge_80_89_title,
        feedback: text.challenge_80_89_feedback,
        microDrill: text.challenge_80_89_microDrill,
      );
    } else if (score >= 70) {
      return FeedbackResult(
        title: text.challenge_70_79_title,
        feedback: text.challenge_70_79_feedback,
        microDrill: text.challenge_70_79_microDrill,
      );
    } else if (score >= 60) {
      return FeedbackResult(
        title: text.challenge_60_69_title,
        feedback: text.challenge_60_69_feedback,
        microDrill: text.challenge_60_69_microDrill,
      );
    } else {
      return FeedbackResult(
        title: text.challenge_0_59_title,
        feedback: text.challenge_0_59_feedback,
        microDrill: text.challenge_0_59_microDrill,
      );
    }
  }
}
