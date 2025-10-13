class SpeechEvaluationModel {
  final String? applicationId;
  final int? eof;
  final String? dtLastResponse;
  final Result? result;
  final String? recordId;
  final Params? params;
  final String? refText;
  final String? tokenId;

  SpeechEvaluationModel({
    this.applicationId,
    this.eof,
    this.dtLastResponse,
    this.result,
    this.recordId,
    this.params,
    this.refText,
    this.tokenId,
  });

  factory SpeechEvaluationModel.fromJson(Map<String, dynamic> json) =>
      SpeechEvaluationModel(
        applicationId: json["applicationId"],
        eof: json["eof"],
        dtLastResponse: json["dtLastResponse"],
        result: json["result"] != null ? Result.fromJson(json["result"]) : null,
        recordId: json["recordId"],
        params: json["params"] != null ? Params.fromJson(json["params"]) : null,
        refText: json["refText"],
        tokenId: json["tokenId"],
      );

  Map<String, dynamic> toJson() => {
    "applicationId": applicationId,
    "eof": eof,
    "dtLastResponse": dtLastResponse,
    "result": result?.toJson(),
    "recordId": recordId,
    "params": params?.toJson(),
    "refText": refText,
    "tokenId": tokenId,
  };
}

class Result {
  final String? duration;
  final List<Word>? words;
  final int? fluency;
  final String? kernelVersion;
  final int? integrity;
  final double? numericDuration;
  final String? rearTone;
  final int? overall;
  final String? resourceVersion;
  final int? rhythm;
  final int? speed;
  final int? pronunciation;

  Result({
    this.duration,
    this.words,
    this.fluency,
    this.kernelVersion,
    this.integrity,
    this.numericDuration,
    this.rearTone,
    this.overall,
    this.resourceVersion,
    this.rhythm,
    this.speed,
    this.pronunciation,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    duration: json["duration"],
    words: json["words"] == null
        ? []
        : List<Word>.from(json["words"].map((x) => Word.fromJson(x))),
    fluency: json["fluency"],
    kernelVersion: json["kernel_version"],
    integrity: json["integrity"],
    numericDuration: (json["numeric_duration"] is int)
        ? (json["numeric_duration"] as int).toDouble()
        : json["numeric_duration"],
    rearTone: json["rear_tone"],
    overall: json["overall"],
    resourceVersion: json["resource_version"],
    rhythm: json["rhythm"],
    speed: json["speed"],
    pronunciation: json["pronunciation"],
  );

  Map<String, dynamic> toJson() => {
    "duration": duration,
    "words": words == null
        ? []
        : List<dynamic>.from(words!.map((x) => x.toJson())),
    "fluency": fluency,
    "kernel_version": kernelVersion,
    "integrity": integrity,
    "numeric_duration": numericDuration,
    "rear_tone": rearTone,
    "overall": overall,
    "resource_version": resourceVersion,
    "rhythm": rhythm,
    "speed": speed,
    "pronunciation": pronunciation,
  };
}

class Word {
  final int? charType;
  final Span? span;
  final List<Phoneme>? phonemes;
  final String? word;
  final List<WordPart>? wordParts;
  final Scores? scores;

  Word({
    this.charType,
    this.span,
    this.phonemes,
    this.word,
    this.wordParts,
    this.scores,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    charType: json["charType"],
    span: json["span"] != null ? Span.fromJson(json["span"]) : null,
    phonemes: json["phonemes"] == null
        ? []
        : List<Phoneme>.from(json["phonemes"].map((x) => Phoneme.fromJson(x))),
    word: json["word"],
    wordParts: json["word_parts"] == null
        ? []
        : List<WordPart>.from(
            json["word_parts"].map((x) => WordPart.fromJson(x)),
          ),
    scores: json["scores"] != null ? Scores.fromJson(json["scores"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "charType": charType,
    "span": span?.toJson(),
    "phonemes": phonemes == null
        ? []
        : List<dynamic>.from(phonemes!.map((x) => x.toJson())),
    "word": word,
    "word_parts": wordParts == null
        ? []
        : List<dynamic>.from(wordParts!.map((x) => x.toJson())),
    "scores": scores?.toJson(),
  };
}

class Phoneme {
  final String? phoneme;
  final Span? span;
  final int? pronunciation;

  Phoneme({this.phoneme, this.span, this.pronunciation});

  factory Phoneme.fromJson(Map<String, dynamic> json) => Phoneme(
    phoneme: json["phoneme"],
    span: json["span"] != null ? Span.fromJson(json["span"]) : null,
    pronunciation: json["pronunciation"],
  );

  Map<String, dynamic> toJson() => {
    "phoneme": phoneme,
    "span": span?.toJson(),
    "pronunciation": pronunciation,
  };
}

class Scores {
  final int? prominence;
  final int? pronunciation;
  final int? overall;

  Scores({this.prominence, this.pronunciation, this.overall});

  factory Scores.fromJson(Map<String, dynamic> json) => Scores(
    prominence: json["prominence"],
    pronunciation: json["pronunciation"],
    overall: json["overall"],
  );

  Map<String, dynamic> toJson() => {
    "prominence": prominence,
    "pronunciation": pronunciation,
    "overall": overall,
  };
}

class Span {
  final int? start;
  final int? end;

  Span({this.start, this.end});

  factory Span.fromJson(Map<String, dynamic> json) =>
      Span(start: json["start"], end: json["end"]);

  Map<String, dynamic> toJson() => {"start": start, "end": end};
}

class WordPart {
  final int? charType;
  final int? beginIndex;
  final int? endIndex;
  final String? part;

  WordPart({this.charType, this.beginIndex, this.endIndex, this.part});

  factory WordPart.fromJson(Map<String, dynamic> json) => WordPart(
    charType: json["charType"],
    beginIndex: json["beginIndex"],
    endIndex: json["endIndex"],
    part: json["part"],
  );

  Map<String, dynamic> toJson() => {
    "charType": charType,
    "beginIndex": beginIndex,
    "endIndex": endIndex,
    "part": part,
  };
}

class Params {
  final App? app;
  final Request? request;
  final Audio? audio;

  Params({this.app, this.request, this.audio});

  factory Params.fromJson(Map<String, dynamic> json) => Params(
    app: json["app"] != null ? App.fromJson(json["app"]) : null,
    request: json["request"] != null ? Request.fromJson(json["request"]) : null,
    audio: json["audio"] != null ? Audio.fromJson(json["audio"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "app": app?.toJson(),
    "request": request?.toJson(),
    "audio": audio?.toJson(),
  };
}

class App {
  final String? sig;
  final String? applicationId;
  final String? userId;
  final String? timestamp;

  App({this.sig, this.applicationId, this.userId, this.timestamp});

  factory App.fromJson(Map<String, dynamic> json) => App(
    sig: json["sig"],
    applicationId: json["applicationId"],
    userId: json["userId"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "sig": sig,
    "applicationId": applicationId,
    "userId": userId,
    "timestamp": timestamp,
  };
}

class Request {
  final String? refText;
  final String? coreType;
  final String? tokenId;

  Request({this.refText, this.coreType, this.tokenId});

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    refText: json["refText"],
    coreType: json["coreType"],
    tokenId: json["tokenId"],
  );

  Map<String, dynamic> toJson() => {
    "refText": refText,
    "coreType": coreType,
    "tokenId": tokenId,
  };
}

class Audio {
  final String? audioType;
  final String? sampleRate;
  final int? channel;
  final int? sampleBytes;

  Audio({this.audioType, this.sampleRate, this.channel, this.sampleBytes});

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
    audioType: json["audioType"],
    sampleRate: json["sampleRate"],
    channel: json["channel"],
    sampleBytes: json["sampleBytes"],
  );

  Map<String, dynamic> toJson() => {
    "audioType": audioType,
    "sampleRate": sampleRate,
    "channel": channel,
    "sampleBytes": sampleBytes,
  };
}
