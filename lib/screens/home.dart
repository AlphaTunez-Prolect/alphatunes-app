import 'package:audio_service/audio_service.dart';
import '../exports.dart';
import 'package:flutter/material.dart';
import '../const/images_string.dart';
import '../statemanagemt/player_manager.dart';
import 'albumscreen.dart';
import 'nowplaying.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlayerManager _playerManager = PlayerManager.instance;

  @override
  void initState() {
    super.initState();
    _playerManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  final List<Map<String, String>> trendingAlbums = [
    {"title": "The Great Commission", "artist": "Dunsin Oyekan", "image": AppImages.album1},
    {"title": "Broken", "artist": "Victoria Orenze", "image": AppImages.album2},
    // {"title": "Names of God", "artist": "Nathaniel Bassey", "image": AppImages.album3},
    // {"title": "True Worshippers", "artist": "Theophilus Sunday", "image": AppImages.album4},
  ];

  final List<Map<String, String>> newReleases = [
    // {"title": "The Glory Experience", "artist": "Dunsin Oyekan", "image": AppImages.album3},
    {"title": "Return Rev 2:4", "artist": "Victoria Orenze", "image": AppImages.album3},
    {"title": "Hallelujah Again", "artist": "Nathaniel Bassey", "image": AppImages.album4},
    // {"title": "Secret Place Sounds", "artist": "Theophilus Sunday", "image": AppImages.album4},
  ];


  final List<Map<String, String>> songs = [
    {
      "title": "I Came By Prayer",
      "artist": "Theophilus Sunday",
      "asset": "assets/audio/I_CAME_BY_PRAYER128k.mp3",
      "image": AppImages.song3,
    },
    {
      "title": "With Joy",
      "artist": "Dunsin Oyekan",
      "asset": "assets/audio/Dunsin-Oyekan-With-Joy-(TunezJam.com).mp3",
      "image": AppImages.song2,
    },
    {
      "title": "Emperor of The Universe",
      "artist": "Dunsin Oyekan",
      "asset": "assets/audio/DUNSIN-OYEKAN-Emperor-of-the-Universe-(CeeNaija.com).mp3",
      "image": AppImages.song1,
    },
  ];

  Future<void> _playSong(Map<String, String> song, [int? index]) async {
    await _playerManager.playSong(song, index ?? 0, playlist: songs);
  }

  /// 🔥 Updated Now Playing Bar with progress + prev/next + duration
  Widget nowPlayingBar() {
    if (!_playerManager.isInitialized || _playerManager.currentTitle == null) {
      return SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayerScreen(
              title: _playerManager.currentTitle ?? "",
              artist: _playerManager.currentArtist ?? "",
              image: _playerManager.currentImage ?? "",
              isPlaying: _playerManager.isPlaying,
              songs: songs,
              currentIndex: _playerManager.currentSongIndex,
              onSongChanged: (index) {
                _playSong(songs[index], index);
              },
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Album artwork
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[800],
                    child: _playerManager.currentImage != null
                        ? Image.asset(
                      _playerManager.currentImage!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.music_note, color: Colors.white54);
                      },
                    )
                        : Icon(Icons.music_note, color: Colors.white54),
                  ),
                ),
                SizedBox(width: 12),

                // Song info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _playerManager.currentTitle ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        _playerManager.currentArtist ?? "",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Control buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.skip_previous,
                        color: _playerManager.hasPrevious ? Colors.white : Colors.white38,
                        size: 24,
                      ),
                      onPressed: _playerManager.hasPrevious
                          ? () async {
                        await _playerManager.playPrevious();
                      }
                          : null,
                    ),
                    IconButton(
                      icon: Icon(
                        _playerManager.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () async {
                        if (_playerManager.isPlaying) {
                          await _playerManager.pause();
                        } else {
                          await _playerManager.play();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.skip_next,
                        color: _playerManager.hasNext ? Colors.white : Colors.white38,
                        size: 24,
                      ),
                      onPressed: _playerManager.hasNext
                          ? () async {
                        await _playerManager.playNext();
                      }
                          : null,
                    ),
                  ],
                ),
              ],
            ),

            // Progress bar
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  _playerManager.positionText,
                  style: TextStyle(color: Colors.white60, fontSize: 10),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      trackHeight: 2,
                    ),
                    child: Slider(
                      value: _playerManager.progress.clamp(0.0, 1.0),
                      onChanged: (value) {
                        if (_playerManager.totalDuration.inMilliseconds > 0) {
                          Duration newPosition = Duration(
                            milliseconds: (value * _playerManager.totalDuration.inMilliseconds).round(),
                          );
                          _playerManager.seek(newPosition);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  _playerManager.durationText,
                  style: TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  String greetingMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good evening";
    } else {
      return "Good night";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      greetingMessage(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    sectionTitle("Trending Albums For You"),
                    gridViewSection(trendingAlbums),

                    sectionTitle("New Releases"),
                    gridViewSection(newReleases),

                    sectionTitle("Recently Played"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        bool isCurrentSong = _playerManager.currentTitle == song['title'];

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              song['image']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[800],
                                  child: Icon(Icons.music_note, color: Colors.white54),
                                );
                              },
                            ),
                          ),
                          title: Text(
                            song['title']!,
                            style: TextStyle(
                              color: isCurrentSong ? Colors.green : Colors.white,
                              fontWeight: isCurrentSong ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            song['artist']!,
                            style: TextStyle(
                              color: isCurrentSong ? Colors.green.shade300 : Colors.white60,
                            ),
                          ),
                          trailing: isCurrentSong && _playerManager.isPlaying
                              ? Icon(Icons.equalizer, color: Colors.green, size: 20)
                              : null,
                          onTap: () => _playSong(song, index),
                        );
                      },
                    ),

                    sectionTitle("More Albums"),
                    gridViewSection(trendingAlbums),
                  ],
                ),
              ),
            ),
            nowPlayingBar(), // 🔥 Updated bar
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget gridViewSection(List<Map<String, String>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumScreen(
                  title: items[index]['title']!,
                  artist: items[index]['artist']!,
                  image: items[index]['image']!,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    items[index]['image']!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: Icon(Icons.album, color: Colors.white54, size: 40),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                items[index]['title']!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                items[index]['artist']!,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
