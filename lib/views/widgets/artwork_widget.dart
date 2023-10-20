import 'package:calibre_mt/controller/song_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      color: Colors.black,
      child: QueryArtworkWidget(
        id: context.watch<SongModelProvider>().id,
        type: ArtworkType.AUDIO,
        artworkHeight: size.height * 0.33,
        artworkWidth: size.width * 0.7,
        artworkFit: BoxFit.cover,
        nullArtworkWidget: Icon(
          Icons.music_note,
          size: size.width * 0.7,
          color: Colors.white12,
        ),
      ),
    );
  }
}
