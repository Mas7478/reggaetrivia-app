import 'package:flutter/material.dart';

import '../theme/reggae_colors.dart';

import 'leaderboard_page.dart';
import 'player_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reggae Trivia"),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(6),
          child: RastaAccentBar(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/reggae_header.png",
                        width: double.infinity,
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Reggae Trivia",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Tebak judul lagu reggae dari artis terkenal dan kumpulkan skor tertinggi di leaderboard.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ReggaeColors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 35),
                    buildMenu(
                      context,
                      icon: Icons.play_circle_fill,
                      title: "Mulai Bermain",
                      subtitle: "Pilih player dan mulai quiz",
                      color: ReggaeColors.green,
                      foreground: Colors.white,
                      page: const PlayerPage(),
                    ),
                    const SizedBox(height: 16),
                    buildMenu(
                      context,
                      icon: Icons.emoji_events,
                      title: "Leaderboard",
                      subtitle: "Lihat ranking pemain",
                      color: ReggaeColors.yellow,
                      foreground: Colors.black,
                      page: const LeaderboardPage(),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                "Version 1.0.0",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenu(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color foreground,
    required Widget page,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 78,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
        child: Row(
          children: [
            Icon(
              icon,
              size: 34,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: foreground.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
