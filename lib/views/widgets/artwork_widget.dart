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
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: QueryArtworkWidget(
        id: context.watch<SongModelProvider>().id,
        type: ArtworkType.AUDIO,
        artworkHeight: 300,
        artworkWidth: 300,
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
