import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../statemanagemt/player_manager.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String title;
  final String artist;
  final String image;
  final bool isPlaying;
  final List<Map<String, String>> songs;
  final int currentIndex;
  final Function(int) onSongChanged;

  const MusicPlayerScreen({
    Key? key,
    required this.title,
    required this.artist,
    required this.image,
    required this.songs,
    required this.currentIndex,
    required this.onSongChanged,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  // final PlayerManager _playerManager = PlayerManager();
  final PlayerManager _playerManager = PlayerManager.instance; // ✅ Correct
  bool isLiked = true;

  @override
  void initState() {
    super.initState();

    // Listen to PlayerManager changes
    _playerManager.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _playNextSong() {
    int nextIndex = (widget.currentIndex + 1) % widget.songs.length;
    _changeSong(nextIndex);
  }

  void _playPreviousSong() {
    int previousIndex = (widget.currentIndex - 1 + widget.songs.length) % widget.songs.length;
    _changeSong(previousIndex);
  }

  void _changeSong(int newIndex) {
    // Notify the home screen about the change
    widget.onSongChanged(newIndex);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Main content - Make this scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Album artwork
                      _buildAlbumArtwork(),

                      const SizedBox(height: 40),

                      // Song info and controls
                      _buildSongInfo(),

                      const SizedBox(height: 30),

                      // Progress bar
                      _buildProgressBar(),

                      const SizedBox(height: 40),

                      // Player controls
                      _buildPlayerControls(),

                      const SizedBox(height: 30),

                      // Bottom actions
                      _buildBottomActions(),

                      // Add some bottom padding for better scrolling experience
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildAlbumArtwork() {
    String currentImage = _playerManager.currentImage ?? widget.image;
    String currentTitle = _playerManager.currentTitle ?? widget.title;
    String currentArtist = _playerManager.currentArtist ?? widget.artist;

    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(currentImage),
          fit: BoxFit.cover,
          onError: (error, stackTrace) {
            // Handle image loading error
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Song title overlay
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentTitle.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 2,
                    width: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentArtist,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongInfo() {
    String currentTitle = _playerManager.currentTitle ?? widget.title;
    String currentArtist = _playerManager.currentArtist ?? widget.artist;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentArtist,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isLiked = !isLiked;
            });
            HapticFeedback.lightImpact();
          },
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.pink : Colors.white70,
            size: 28,
          ),
        ),
        const SizedBox(width: 20),
        const Icon(
          Icons.playlist_add,
          color: Colors.white70,
          size: 28,
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white30,
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            trackHeight: 2,
          ),
          child: Slider(
            value: _playerManager.progress.clamp(0.0, 1.0),
            min: 0,
            max: 1.0,
            onChanged: (value) {
              Duration newPosition = Duration(
                milliseconds: (value * _playerManager.totalDuration.inMilliseconds).round(),
              );
              _playerManager.seek(newPosition);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _playerManager.positionText,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              Text(
                _playerManager.durationText,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Shuffle
        const Icon(
          Icons.shuffle,
          color: Colors.white70,
          size: 24,
        ),

        // Previous
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _playPreviousSong();
          },
          child: const Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 36,
          ),
        ),

        // Play/Pause
        GestureDetector(
          onTap: () async {
            if (_playerManager.isPlaying) {
              await _playerManager.pause();
            } else {
              await _playerManager.play();
            }
            HapticFeedback.mediumImpact();
          },
          child: Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _playerManager.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
              size: 32,
            ),
          ),
        ),

        // Next
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _playNextSong();
          },
          child: const Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 36,
          ),
        ),

        // Repeat
        const Icon(
          Icons.repeat,
          color: Colors.white70,
          size: 24,
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Share
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // Implement share functionality
          },
          child: const Icon(
            Icons.share,
            color: Colors.white70,
            size: 24,
          ),
        ),

        // Lyrics
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // Implement lyrics functionality
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Lyrics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Download
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // Implement download functionality
          },
          child: const Icon(
            Icons.download_outlined,
            color: Colors.white70,
            size: 24,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // PlayerManager is a singleton, so no need to dispose manually
    super.dispose();
  }
}