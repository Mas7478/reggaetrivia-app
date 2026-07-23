import 'package:flutter/material.dart';

import '../models/player_model.dart';
import '../services/api_service.dart';
import '../theme/reggae_colors.dart';

import 'game_page.dart';
import 'history_page.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late Future<List<PlayerModel>> players;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    setState(() {
      players = ApiService.getPlayers();
    });

    await players;
  }

  void playGame(PlayerModel player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePage(
          playerId: player.id,
        ),
      ),
    );
  }

  void openHistory(PlayerModel player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryPage(
          playerId: player.id,
        ),
      ),
    );
  }

  Future<void> addOrEditPlayer({
    PlayerModel? player,
  }) async {
    final controller = TextEditingController(
      text: player?.nama ?? "",
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: ReggaeColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            player == null ? "Tambah Player" : "Edit Player",
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: "Nama Player",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final nama = controller.text.trim();

    if (nama.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Nama player tidak boleh kosong.",
          ),
        ),
      );

      return;
    }

    try {
      if (player == null) {
        await ApiService.createPlayer(nama);
      } else {
        await ApiService.updatePlayer(
          id: player.id,
          nama: nama,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            player == null
                ? "Player berhasil ditambahkan."
                : "Player berhasil diperbarui.",
          ),
        ),
      );

      refresh();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> deletePlayer(
    PlayerModel player,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: ReggaeColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Hapus Player"),
          content: Text(
            "Yakin ingin menghapus \"${player.nama}\"?\n\n"
            "Leaderboard dan history player ini juga akan ikut dihapus.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ReggaeColors.red,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await ApiService.deletePlayer(player.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Player berhasil dihapus.",
          ),
        ),
      );

      refresh();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Widget playerCard(PlayerModel player) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: ReggaeColors.green,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.nama,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Player ID : ${player.id}",
                        style: const TextStyle(
                          color: ReggaeColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Main"),
                    onPressed: () {
                      playGame(player);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.history),
                    label: const Text("History"),
                    onPressed: () {
                      openHistory(player);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.edit,
                      color: ReggaeColors.yellow,
                    ),
                    label: const Text("Edit"),
                    onPressed: () {
                      addOrEditPlayer(
                        player: player,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.delete,
                      color: ReggaeColors.red,
                    ),
                    label: const Text("Hapus"),
                    onPressed: () {
                      deletePlayer(player);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Player"),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(6),
          child: RastaAccentBar(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ReggaeColors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text("Tambah"),
        onPressed: () {
          addOrEditPlayer();
        },
      ),
      body: FutureBuilder<List<PlayerModel>>(
        future: players,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 120),
                  Icon(
                    Icons.person_off,
                    size: 90,
                    color: ReggaeColors.grey,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Belum ada Player",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Text(
                      "Tekan tombol Tambah untuk membuat player baru dan mulai bermain Reggae Trivia.",
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
              padding: const EdgeInsets.fromLTRB(
                14,
                14,
                14,
                90,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return playerCard(
                  data[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
