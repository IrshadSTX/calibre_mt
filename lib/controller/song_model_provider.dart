import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongModelProvider with ChangeNotifier {
  int _id = 0;

  int get id => _id;
  void setId(int id) {
    _id = id;
    notifyListeners();
  }
}

class SongController {
  static AudioPlayer audioPlayer = AudioPlayer();
  static List<SongModel> playingSong = [];
  static int currentIndexes = -1;
  static ConcatenatingAudioSource createSongList(List<SongModel> elements) {
    List<AudioSource> songList = [];
    playingSong = elements;
    for (var element in elements) {
      songList.add(
        AudioSource.uri(
          Uri.parse(element.uri!),
        ),
      );
    }
    return ConcatenatingAudioSource(children: songList);
  }
}
