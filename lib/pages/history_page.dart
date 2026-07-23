import 'package:flutter/material.dart';

import '../models/history_model.dart';
import '../services/api_service.dart';
import '../theme/reggae_colors.dart';

class HistoryPage extends StatefulWidget {
  final int playerId;

  const HistoryPage({
    super.key,
    required this.playerId,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<HistoryModel>> historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    historyFuture = ApiService.getHistory(widget.playerId);
  }

  Future<void> refresh() async {
    setState(() {
      _loadHistory();
    });
    await historyFuture;
  }

  Widget musicImage(String thumbnail) {
    if (thumbnail.isEmpty) {
      return Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: ReggaeColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.music_note,
          color: ReggaeColors.yellow,
          size: 32,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        thumbnail,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: 70,
            height: 70,
            color: ReggaeColors.card,
            child: const Icon(
              Icons.music_note,
              color: ReggaeColors.yellow,
              size: 32,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History Lagu"),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(6),
          child: RastaAccentBar(),
        ),
      ),
      body: FutureBuilder<List<HistoryModel>>(
        future: historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            final errorString = snapshot.error.toString().toLowerCase();
            final displayError = (errorString.contains('socketexception') ||
                    errorString.contains('failed host lookup') ||
                    errorString.contains('clientexception'))
                ? "Gagal terhubung ke internet, periksa koneksi dan coba lagi"
                : snapshot.error
                    .toString()
                    .replaceFirst(RegExp(r'^.*Exception:\s*'), '');

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  displayError,
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
              onRefresh: refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 130),
                  Icon(
                    Icons.history,
                    size: 90,
                    color: ReggaeColors.grey,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Belum ada history lagu",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Mainkan Reggae Trivia untuk mulai menyimpan history lagu.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: refresh,
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
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        musicImage(item.thumbnail),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.judul,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.artis,
                                style: const TextStyle(
                                  color: ReggaeColors.yellow,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 15,
                                    color: ReggaeColors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item.shownAt,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: ReggaeColors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
