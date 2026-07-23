class PlayerModel {
  final int id;
  final String nama;

  PlayerModel({
    required this.id,
    required this.nama,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: int.tryParse(json["id"].toString()) ?? 0,
      nama: json["nama"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama": nama,
    };
  }
}
