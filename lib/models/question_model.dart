class QuestionModel {
  final String youtubeId;
  final String thumbnail;
  final String artist;
  final String answer;
  final List<String> options;

  QuestionModel({
    required this.youtubeId,
    required this.thumbnail,
    required this.artist,
    required this.answer,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final question = json["question"];

    return QuestionModel(
      youtubeId: question["youtube_id"] ?? "",
      thumbnail: question["thumbnail"] ?? "",
      artist: question["artist"] ?? "",
      answer: question["answer"] ?? "",
      options: List<String>.from(json["options"] ?? []),
    );
  }
}
