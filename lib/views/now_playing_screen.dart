import 'package:calibre_mt/controller/song_model_provider.dart';
import 'package:calibre_mt/views/widgets/artwork_widget.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query_platform_interface/src/models/song_model.dart';
import 'package:text_scroll/text_scroll.dart';

class MediaPlayerScreen extends StatefulWidget {
  MediaPlayerScreen({super.key, required this.songModelList});

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
  final List<SongModel> songModelList;
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  bool _isPlaying = false;
  int currentIndex = 0;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  void playSong() {
    SongController.audioPlayer.play();
    SongController.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    SongController.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  void initState() {
    SongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        setState(() {
          currentIndex = index;
        });
        SongController.currentIndexes = index;
      }
    });
    super.initState();
    playSong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Now Playing',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color.fromARGB(255, 32, 34, 34),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ArtWorkWidget(),
              const SizedBox(
                height: 10,
              ),
              TextScroll(
                widget.songModelList[currentIndex].displayNameWOExt
                    .toUpperCase(),
                mode: TextScrollMode.endless,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                widget.songModelList[currentIndex].artist.toString() ==
                        "<unknown>"
                    ? "Unknown Artist"
                    : widget.songModelList[currentIndex].artist.toString(),
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    _formatDuration(_position),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 183, 163, 163),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      activeColor: Colors.white38,
                      min: const Duration(microseconds: 0).inSeconds.toDouble(),
                      value: _position.inSeconds.toDouble(),
                      max: _duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          changeToSeconds(value.toInt());
                          value = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    _formatDuration(_duration),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 183, 163, 163),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 50,
                    onPressed: () {
                      if (SongController.audioPlayer.hasPrevious) {
                        SongController.audioPlayer.seekToPrevious();
                      }
                      _isPlaying = !_isPlaying;
                    },
                    icon: const Icon(
                      Icons.skip_previous_sharp,
                      color: Colors.white70,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 20, 5, 46),
                        shape: const CircleBorder()),
                    onPressed: () async {
                      if (SongController.audioPlayer.playing) {
                        setState(() {});
                        await SongController.audioPlayer.pause();
                      } else {
                        await SongController.audioPlayer.play();
                        setState(() {});
                      }
                    },
                    child: StreamBuilder<bool>(
                      stream: SongController.audioPlayer.playingStream,
                      builder: (context, snapshot) {
                        bool? playingStage = snapshot.data;
                        if (playingStage != null && playingStage) {
                          return const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.pause_circle,
                              color: Colors.white,
                              size: 80,
                            ),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.play_circle,
                              color: Colors.white,
                              size: 80,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  IconButton(
                    iconSize: 50,
                    onPressed: () {
                      if (SongController.audioPlayer.hasNext) {
                        SongController.audioPlayer.seekToNext();
                      }
                    },
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    SongController.audioPlayer.seek(duration);
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }
}
