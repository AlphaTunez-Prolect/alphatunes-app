import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Song {
  final String title;
  final String artist;
  final String albumArt;
  final Color dominantColor;

  Song({
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.dominantColor,
  });
}

class TodaysTopHitScreen extends StatefulWidget {
  @override
  _TodaysTopHitScreenState createState() => _TodaysTopHitScreenState();
}

class _TodaysTopHitScreenState extends State<TodaysTopHitScreen> {
  bool isLiked = false;
  bool isShuffleOn = false;
  int currentlyPlaying = -1;

  final List<Song> songs = [
    Song(
      title: 'Emperor Of The Universe',
      artist: 'Dunsin Oyekan, Theophilus Sunday',
      albumArt: '🎵',
      dominantColor: Colors.purple,
    ),
    Song(
      title: 'Jehovah Shammah',
      artist: 'Nathaniel Bassey, Chioma Jesus',
      albumArt: '🎵',
      dominantColor: Colors.orange,
    ),
    Song(
      title: 'Wonder',
      artist: 'Mercy Chinwo',
      albumArt: '🎵',
      dominantColor: Colors.brown,
    ),
    Song(
      title: 'I Came By Prayer',
      artist: 'Theophilus Sunday',
      albumArt: '🎵',
      dominantColor: Colors.blueGrey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D2D2D),
              Color(0xFF1A1A1A),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header section with hero image
              _buildHeroSection(),

              // Playlist controls
              _buildPlaylistControls(),

              // Song list
              Expanded(
                child: _buildSongList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 400,
      margin: const EdgeInsets.all(20),
      child: Stack(
        children: [
          // Background blur effect
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=400&h=400&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),

          // Main content overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),

          // Content
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Top Hit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Stream the hottest tracks of the moment with our curated playlist.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isShuffleOn = !isShuffleOn;
                        });
                        HapticFeedback.lightImpact();
                      },
                      child: Icon(
                        Icons.shuffle,
                        color: isShuffleOn ? Colors.green : Colors.white70,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                        HapticFeedback.lightImpact();
                      },
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.green : Colors.white70,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.download_outlined,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.more_vert,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // Play button
          GestureDetector(
            onTap: () {
              setState(() {
                currentlyPlaying = currentlyPlaying == -1 ? 0 : -1;
              });
              HapticFeedback.mediumImpact();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                currentlyPlaying != -1 ? Icons.pause : Icons.play_arrow,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.more_vert,
            color: Colors.white70,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildSongList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return _buildSongTile(songs[index], index);
      },
    );
  }

  Widget _buildSongTile(Song song, int index) {
    final bool isCurrentlyPlaying = currentlyPlaying == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentlyPlaying = isCurrentlyPlaying ? -1 : index;
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Album art / Play indicator
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: song.dominantColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: isCurrentlyPlaying
                    ? Icon(
                  Icons.pause,
                  color: Colors.green,
                  size: 24,
                )
                    : Text(
                  song.albumArt,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      color: isCurrentlyPlaying ? Colors.green : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: isCurrentlyPlaying ? Colors.green.withOpacity(0.8) : Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // More options
            GestureDetector(
              onTap: () {
                _showSongOptions(song);
              },
              child: const Icon(
                Icons.more_vert,
                color: Colors.white60,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSongOptions(Song song) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D2D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Song info header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: song.dominantColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        song.albumArt,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          song.artist,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Options
              _buildBottomSheetOption(Icons.favorite_border, 'Like'),
              _buildBottomSheetOption(Icons.playlist_add, 'Add to playlist'),
              _buildBottomSheetOption(Icons.album, 'Go to album'),
              _buildBottomSheetOption(Icons.person, 'Go to artist'),
              _buildBottomSheetOption(Icons.share, 'Share'),
              _buildBottomSheetOption(Icons.download, 'Download'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption(IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}