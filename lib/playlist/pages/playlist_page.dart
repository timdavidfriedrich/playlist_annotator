import 'package:flutter/material.dart';
import 'package:log/log.dart';
import 'package:playlist_annotator/core/models/playlist.dart';
import 'package:playlist_annotator/playlist/widgets/song_tile.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;
  const PlaylistPage({super.key, required this.playlist});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<ExpansionTileController> controllers = [];

  void collapseAll() {
    for (var controller in controllers) {
      try {
        controller.collapse();
      } catch (e) {
        Log.error(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.playlist.songs.length, (index) => ExpansionTileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 4),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.playlist.imageUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              widget.playlist.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(widget.playlist.description),
            const SizedBox(height: 16),
            Row(children: [
              Text(widget.playlist.owners.firstOrNull?.name ?? "Unknown"),
              Text(" • ${widget.playlist.songs.length} songs"),
              const Spacer(),
              TextButton(
                onPressed: collapseAll,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Collapse all"),
                    SizedBox(width: 4),
                    Icon(Icons.expand_less_rounded),
                  ],
                ),
              )
            ]),
            const SizedBox(height: 32),
            for (int index = 0; index < widget.playlist.songs.length; index++)
              SongTile(
                song: widget.playlist.songs.elementAt(index),
                controller: controllers.elementAt(index),
              )
          ],
        ),
      ),
    );
  }
}
