import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../const/images_string.dart'; // Make sure this file and image paths are valid

class AssetAudioPlayerScreen extends StatefulWidget {
  @override
  _AssetAudioPlayerScreenState createState() => _AssetAudioPlayerScreenState();
}

class _AssetAudioPlayerScreenState extends State<AssetAudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();

  String? _currentTitle;
  String? _currentArtist;
  String? _currentImage;
  bool _isPlaying = false;

  final List<Map<String, String>> trendingAlbums = [
    {"title": "Scenery of Time", "artist": "Paul Paul", "image": AppImages.album1},
    {"title": "Scenery of Time", "artist": "Paul Paul", "image": AppImages.album2},
  ];

  final List<Map<String, String>> newReleases = [
    {"title": "Scenery of Time", "artist": "Paul Paul", "image": AppImages.album3},
    {"title": "Scenery of Time", "artist": "Paul Paul", "image": AppImages.album4},
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

  Future<void> _playSong(Map<String, String> song) async {
    try {
      await _player.setAsset(song['asset']!);
      await _player.play();
      setState(() {
        _currentTitle = song['title'];
        _currentArtist = song['artist'];
        _currentImage = song['image'];
        _isPlaying = true;
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Widget nowPlayingBar() {
    if (_currentTitle == null) return SizedBox();

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(_currentImage!, width: 50, height: 50, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_currentTitle!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(_currentArtist!, style: TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.skip_previous, color: Colors.white),
            onPressed: () {}, // Add skip logic
          ),
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
            onPressed: () async {
              if (_isPlaying) {
                await _player.pause();
              } else {
                await _player.play();
              }
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.skip_next, color: Colors.white),
            onPressed: () {}, // Add skip logic
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Asset Audio Player"),
        backgroundColor: Colors.black,
      ),
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
                      "Good morning",
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
                        return ListTile(
                          leading: Image.asset(song['image']!, width: 50, height: 50, fit: BoxFit.cover),
                          title: Text(song['title']!, style: TextStyle(color: Colors.white)),
                          subtitle: Text(song['artist']!, style: TextStyle(color: Colors.white60)),
                          onTap: () => _playSong(song),
                        );
                      },
                    ),

                    sectionTitle("More Albums"),
                    gridViewSection(trendingAlbums),
                  ],
                ),
              ),
            ),
            nowPlayingBar(),
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
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(items[index]['image']!, fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            SizedBox(height: 5),
            Text(items[index]['title']!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(items[index]['artist']!, style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        );
      },
    );
  }
}
