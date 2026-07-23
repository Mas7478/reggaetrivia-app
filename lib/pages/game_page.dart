import 'package:flutter/material.dart';

import '../models/question_model.dart';
import '../services/api_service.dart';
import '../theme/reggae_colors.dart';
import 'result_page.dart';

class GamePage extends StatefulWidget {
  final int playerId;

  const GamePage({
    super.key,
    required this.playerId,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int maxQuestion = 10;

  bool loading = true;
  bool answered = false;
  QuestionModel? question;
  String? errorMessage;

  int score = 0;
  int correct = 0;
  int wrong = 0;
  int number = 1;

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  Future<void> loadQuestion() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      answered = false;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getQuestion();

      if (!mounted) return;

      setState(() {
        question = data;
        loading = false;
      });

      ApiService.saveHistory(
        playerId: widget.playerId,
        youtubeId: data.youtubeId,
        judul: data.answer,
        artis: data.artist,
        thumbnail: data.thumbnail,
      ).catchError((_) {});
    } catch (e) {
      if (!mounted) return;

      final errorString = e.toString().toLowerCase();
      final displayError = (errorString.contains('socketexception') ||
              errorString.contains('failed host lookup') ||
              errorString.contains('clientexception'))
          ? "Gagal terhubung ke internet, periksa koneksi dan coba lagi"
          : e.toString().replaceFirst(RegExp(r'^.*Exception:\s*'), '');

      setState(() {
        loading = false;
        errorMessage = displayError;
      });
    }
  }

  Future<void> answer(String option) async {
    if (answered) return;

    setState(() {
      answered = true;
    });

    final q = question;
    if (q == null) return;

    final bool isCorrect = option == q.answer;

    if (isCorrect) {
      score += 10;
      correct++;
    } else {
      score -= 10;
      wrong++;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: ReggaeColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? ReggaeColors.green : ReggaeColors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isCorrect ? "Jawaban Benar" : "Jawaban Salah",
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCorrect
                    ? "Keren bang! Kamu mendapatkan 10 poin."
                    : "Waduh... poinmu minus 10.",
              ),
              const SizedBox(height: 16),
              const Text(
                "Jawaban yang benar:",
              ),
              const SizedBox(height: 6),
              Text(
                q.answer,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ReggaeColors.yellow,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                q.artist,
                style: const TextStyle(
                  color: ReggaeColors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ReggaeColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Score : $score",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: score < 0 ? ReggaeColors.red : null,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                number >= maxQuestion ? "Lihat Hasil" : "Lanjut",
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (number >= maxQuestion) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            playerId: widget.playerId,
            score: score,
            totalQuestion: maxQuestion,
            correctAnswer: correct,
            wrongAnswer: wrong,
          ),
        ),
      );
      return;
    }

    setState(() {
      number++;
    });

    loadQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Soal $number / $maxQuestion",
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(6),
          child: RastaAccentBar(),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text("Score"),
                                  Text(
                                    "$score",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: score < 0
                                          ? ReggaeColors.red
                                          : ReggaeColors.green,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text("Benar"),
                                  Text(
                                    "$correct",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: ReggaeColors.yellow,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text("Salah"),
                                  Text(
                                    "$wrong",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: ReggaeColors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: number / maxQuestion,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(20),
                        color: ReggaeColors.yellow,
                        backgroundColor: ReggaeColors.surface,
                      ),
                      const SizedBox(height: 25),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          question!.thumbnail,
                          width: 260,
                          height: 260,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              width: 260,
                              height: 260,
                              color: ReggaeColors.surface,
                              child: const Icon(
                                Icons.music_note,
                                size: 90,
                                color: ReggaeColors.yellow,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Tebak Judul Lagu",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        question!.artist,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          color: ReggaeColors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ...question!.options.map(
                        (option) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    answered ? null : () => answer(option),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Text(
                                    option,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
    );
  }
}
