import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:log/log.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';
import 'package:playlist_annotator/features/playlist/widgets/song_tile.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 4),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Measurements.normalPadding),
                  child: Image.network(
                    widget.playlist.imageUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Measurements.mediumPadding),
            Text(
              widget.playlist.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: Measurements.normalPadding),
            Text(widget.playlist.description),
            const SizedBox(height: Measurements.normalPadding),
            Row(children: [
              Text(widget.playlist.ownerSpotifyNames),
              const Text(" • "),
              Text("song_count_label".trParams({"count": "${widget.playlist.songs.length}"})),
              const Spacer(),
              TextButton(
                onPressed: collapseAll,
                child: Text("collapse_all_label".tr),
              )
            ]),
            const SizedBox(height: Measurements.normalPadding),
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
