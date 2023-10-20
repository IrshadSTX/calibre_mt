import 'package:calibre_mt/controller/song_model_provider.dart';
import 'package:calibre_mt/views/now_playing_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final _audioQuery = OnAudioQuery();

final _audioPlayer = AudioPlayer();

class _HomeScreenState extends State<HomeScreen> {
  bool _hasPermission = false;
  void initState() {
    super.initState();

    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Song List',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
            padding: const EdgeInsets.all(8.0),
            child: !_hasPermission
                ? Container()
                : FutureBuilder<List<SongModel>>(
                    future: _audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true,
                    ),
                    builder: (context, item) {
                      if (item.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      if (item.data!.isEmpty) {
                        return const Center(
                            child: Text(
                          "No Songs found",
                          style: TextStyle(color: Colors.white),
                        ));
                      }

                      return SizedBox(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            return Container(
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(width: 1, color: Colors.white),
                              ),
                              child: ListTile(
                                leading: QueryArtworkWidget(
                                  id: item.data![index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget:
                                      const Icon(Icons.music_note),
                                ),
                                title: Text(
                                  item.data![index].displayNameWOExt,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                                iconColor: Colors.white,
                                subtitle: Text("${item.data![index].artist}",
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.blueGrey,
                                        fontSize: 12)),
                                onTap: () {
                                  SongController.audioPlayer.setAudioSource(
                                      SongController.createSongList(item.data!),
                                      initialIndex: index);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MediaPlayerScreen(
                                        songModelList: item.data!,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 5,
                          ),
                          itemCount: item.data!.length,
                        ),
                      );
                    },
                  ),
          )),
    );
  }
}
