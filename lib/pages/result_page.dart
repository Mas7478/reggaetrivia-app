import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../theme/reggae_colors.dart';

import 'game_page.dart';
import 'home_page.dart';

class ResultPage extends StatefulWidget {
  final int playerId;
  final int score;
  final int totalQuestion;
  final int correctAnswer;
  final int wrongAnswer;

  const ResultPage({
    super.key,
    required this.playerId,
    required this.score,
    required this.totalQuestion,
    required this.correctAnswer,
    required this.wrongAnswer,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool saving = true;

  String? error;

  @override
  void initState() {
    super.initState();
    saveResult();
  }

  Future<void> saveResult() async {
    try {
      await ApiService.saveScore(
        playerId: widget.playerId,
        skor: widget.score,
        totalSoal: widget.totalQuestion,
        benar: widget.correctAnswer,
      );
    } catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final persen = (widget.correctAnswer / widget.totalQuestion * 100).round();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Hasil Permainan"),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(6),
          child: RastaAccentBar(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 90,
                    color: ReggaeColors.yellow,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Permainan Selesai!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "${widget.score}",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: widget.score < 0
                          ? ReggaeColors.red
                          : ReggaeColors.green,
                    ),
                  ),
                  const Text(
                    "POINT",
                    style: TextStyle(
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Card(
                    color: ReggaeColors.surface,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.check_circle,
                            color: ReggaeColors.green,
                          ),
                          title: const Text(
                            "Jawaban Benar",
                          ),
                          trailing: Text(
                            "${widget.correctAnswer}/${widget.totalQuestion}",
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.cancel,
                            color: ReggaeColors.red,
                          ),
                          title: const Text(
                            "Jawaban Salah",
                          ),
                          trailing: Text(
                            "${widget.wrongAnswer}/${widget.totalQuestion}",
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.percent,
                            color: ReggaeColors.yellow,
                          ),
                          title: const Text(
                            "Akurasi",
                          ),
                          trailing: Text(
                            "$persen %",
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.stars,
                            color: ReggaeColors.red,
                          ),
                          title: const Text(
                            "Skor Akhir",
                          ),
                          trailing: Text(
                            "${widget.score}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.score < 0 ? ReggaeColors.red : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (saving)
                    const Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text(
                          "Menyimpan leaderboard...",
                        ),
                      ],
                    ),
                  if (!saving && error != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Text(
                        error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ReggaeColors.red,
                        ),
                      ),
                    ),
                  if (!saving)
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.replay,
                            ),
                            label: const Text(
                              "Main Lagi",
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GamePage(
                                    playerId: widget.playerId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(
                              Icons.home,
                            ),
                            label: const Text(
                              "Kembali ke Home",
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomePage(),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
