class HistoryModel {
  final int id;
  final String youtubeId;
  final String judul;
  final String artis;
  final String thumbnail;
  final String shownAt;

  HistoryModel({
    required this.id,
    required this.youtubeId,
    required this.judul,
    required this.artis,
    required this.thumbnail,
    required this.shownAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: int.tryParse(json["id"].toString()) ?? 0,
      youtubeId: json["youtube_id"] ?? "",
      judul: json["judul"] ?? "",
      artis: json["artis"] ?? "",
      thumbnail: json["thumbnail"] ?? "",
      shownAt: json["shown_at"] ?? "",
    );
  }
}
