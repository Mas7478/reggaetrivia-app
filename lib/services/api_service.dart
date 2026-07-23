import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/history_model.dart';
import '../models/leaderboard_model.dart';
import '../models/player_model.dart';
import '../models/question_model.dart';

class ApiService {
  ApiService._();

  static const String baseUrl = "https://reggaetrivia.wasmer.app/api";
  static const Duration timeout = Duration(seconds: 15);
  static const Map<String, String> _headers = {
    "Content-Type": "application/json",
  };

  static Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception("Server Error (${response.statusCode})");
    }

    final json = jsonDecode(response.body);
    if (json is! Map<String, dynamic>) {
      throw Exception("Response server tidak valid.");
    }

    if (json["success"] != true) {
      throw Exception(json["message"] ?? "Terjadi kesalahan.");
    }

    return json;
  }

  static Future<http.Response> _safeApiCall(
      Future<http.Response> Function() apiCall) async {
    try {
      return await apiCall().timeout(timeout);
    } on TimeoutException {
      throw Exception("Koneksi internet lambat / timeout.");
    } on SocketException {
      throw Exception("Gagal terhubung ke internet. Periksa koneksi Anda.");
    } on http.ClientException {
      throw Exception("Tidak dapat terhubung ke server.");
    } catch (e) {
      throw Exception("Terjadi kesalahan jaringan: $e");
    }
  }

  static Future<http.Response> _get(String url) {
    return _safeApiCall(() => http.get(Uri.parse(url)));
  }

  static Future<http.Response> _post(String url, Map<String, dynamic> body) {
    return _safeApiCall(
      () =>
          http.post(Uri.parse(url), headers: _headers, body: jsonEncode(body)),
    );
  }

  static Future<http.Response> _put(String url, Map<String, dynamic> body) {
    return _safeApiCall(
      () => http.put(Uri.parse(url), headers: _headers, body: jsonEncode(body)),
    );
  }

  static Future<http.Response> _delete(String url) {
    return _safeApiCall(() => http.delete(Uri.parse(url)));
  }

  static Future<QuestionModel> getQuestion({String keyword = "reggae"}) async {
    final response = await _get(
      "$baseUrl/game.php?keyword=${Uri.encodeComponent(keyword)}",
    );
    final json = _decode(response);
    return QuestionModel.fromJson(json["data"]);
  }

  static Future<List<PlayerModel>> getPlayers() async {
    final response = await _get("$baseUrl/player.php");
    final json = _decode(response);
    final List data = json["data"] ?? [];
    return data.map((e) => PlayerModel.fromJson(e)).toList();
  }

  static Future<PlayerModel> getPlayer(int id) async {
    final response = await _get("$baseUrl/player.php?id=$id");
    final json = _decode(response);
    return PlayerModel.fromJson(json["data"]);
  }

  static Future<int> createPlayer(String nama) async {
    final response = await _post("$baseUrl/player.php", {"nama": nama});
    final json = _decode(response);
    return json["data"]["player_id"];
  }

  static Future<void> updatePlayer(
      {required int id, required String nama}) async {
    final response =
        await _put("$baseUrl/player.php", {"id": id, "nama": nama});
    _decode(response);
  }

  static Future<void> deletePlayer(int id) async {
    final response = await _delete("$baseUrl/player.php?id=$id");
    _decode(response);
  }

  static Future<void> saveScore({
    required int playerId,
    required int skor,
    required int totalSoal,
    required int benar,
  }) async {
    final response = await _post(
      "$baseUrl/leaderboard.php",
      {
        "player_id": playerId,
        "skor": skor,
        "total_soal": totalSoal,
        "binary": benar,
      },
    );
    _decode(response);
  }

  static Future<List<LeaderboardModel>> getLeaderboard() async {
    final response = await _get("$baseUrl/leaderboard.php");
    final json = _decode(response);
    final List data = json["data"] ?? [];
    return data.map((e) => LeaderboardModel.fromJson(e)).toList();
  }

  static Future<void> saveHistory({
    required int playerId,
    required String youtubeId,
    required String judul,
    required String artis,
    required String thumbnail,
  }) async {
    final response = await _post(
      "$baseUrl/history.php",
      {
        "player_id": playerId,
        "youtube_id": youtubeId,
        "judul": judul,
        "artis": artis,
        "thumbnail": thumbnail,
      },
    );
    _decode(response);
  }

  static Future<List<HistoryModel>> getHistory(int playerId) async {
    final response = await _get("$baseUrl/history.php?player_id=$playerId");
    final json = _decode(response);
    final List data = json["data"] ?? [];
    return data.map((e) => HistoryModel.fromJson(e)).toList();
  }
}
