class LeaderboardModel {
  final int id;
  final String nama;
  final int skor;
  final int totalSoal;
  final int benar;
  final String waktuMain;

  LeaderboardModel({
    required this.id,
    required this.nama,
    required this.skor,
    required this.totalSoal,
    required this.benar,
    required this.waktuMain,
  });

  int get salah => totalSoal - benar;

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      id: int.tryParse(json["id"].toString()) ?? 0,
      nama: json["nama"] ?? "",
      skor: int.tryParse(json["skor"].toString()) ?? 0,
      totalSoal: int.tryParse(json["total_soal"].toString()) ?? 0,
      benar: int.tryParse(json["benar"].toString()) ?? 0,
      waktuMain: json["waktu_main"] ?? "",
    );
  }
}
