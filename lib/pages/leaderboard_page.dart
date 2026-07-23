import 'package:flutter/material.dart';

import '../models/leaderboard_model.dart';
import '../services/api_service.dart';
import '../theme/reggae_colors.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<LeaderboardModel>> _leaderboardFuture;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  void _loadLeaderboard() {
    _leaderboardFuture = ApiService.getLeaderboard();
  }

  Future<void> refreshLeaderboard() async {
    setState(() {
      _loadLeaderboard();
    });
    await _leaderboardFuture;
  }

  String medal(int index) {
    switch (index) {
      case 0:
        return "🥇";
      case 1:
        return "🥈";
      case 2:
        return "🥉";
      default:
        return "#${index + 1}";
    }
  }

  Color medalColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFF4CC);
      case 1:
        return const Color(0xFFE2E8F0);
      case 2:
        return const Color(0xFFFFE8D6);
      default:
        return ReggaeColors.green.withAlpha(40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(6),
          child: RastaAccentBar(),
        ),
      ),
      body: FutureBuilder<List<LeaderboardModel>>(
        future: _leaderboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            final errorMessage = snapshot.error
                .toString()
                .replaceFirst(RegExp(r'^.*Exception:\s*'), '');

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return RefreshIndicator(
              onRefresh: refreshLeaderboard,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 140),
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 90,
                    color: ReggaeColors.grey,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Leaderboard masih kosong",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshLeaderboard,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(14),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: medalColor(index),
                          child: Text(
                            medal(index),
                            style: TextStyle(
                              fontSize: index < 3 ? 30 : 18,
                              fontWeight: index < 3
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color:
                                  index < 3 ? Colors.black : ReggaeColors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nama,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Jawaban Benar : ${item.benar}/${item.totalSoal}",
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Jawaban Salah : ${item.salah}/${item.totalSoal}",
                                style: const TextStyle(
                                  color: ReggaeColors.red,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.waktuMain,
                                style: const TextStyle(
                                  color: ReggaeColors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Icon(
                              Icons.stars,
                              color: ReggaeColors.yellow,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${item.skor}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: item.skor < 0
                                    ? ReggaeColors.red
                                    : ReggaeColors.green,
                              ),
                            ),
                            const Text(
                              "POINT",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
