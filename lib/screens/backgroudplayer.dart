import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../statemanagemt/player_manager.dart';

class BackgroundMusicPlayer extends StatefulWidget {
  final List<Map<String, String>> songs;
  final int initialIndex;

  const BackgroundMusicPlayer({
    Key? key,
    required this.songs,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<BackgroundMusicPlayer> createState() => _BackgroundMusicPlayerState();
}

class _BackgroundMusicPlayerState extends State<BackgroundMusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerManager>(
      builder: (context, playerManager, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.8), Colors.purple.withOpacity(0.3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Song Info
              if (playerManager.currentTitle != null) ...[
                Text(
                  playerManager.currentTitle!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  playerManager.currentArtist ?? 'Unknown Artist',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],

              // Album Art
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRectButton(
                  borderRadius: BorderRadius.circular(15),
                  child: playerManager.currentImage != null
                      ? Image.asset(
                    playerManager.currentImage!,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.music_note,
                      size: 80,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Progress Bar
              Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.pinkAccent,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.pinkAccent,
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      value: playerManager.progress.clamp(0.0, 1.0),
                      onChanged: (value) {
                        final newPosition = Duration(
                          milliseconds: (value * playerManager.totalDuration.inMilliseconds).round(),
                        );
                        playerManager.seek(newPosition);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          playerManager.positionText,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          playerManager.durationText,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      playerManager.playPrevious();
                    },
                    icon: const Icon(Icons.skip_previous, size: 40, color: Colors.white),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pinkAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (playerManager.isPlaying) {
                          playerManager.pause();
                        } else {
                          playerManager.resume();
                        }
                      },
                      icon: Icon(
                        playerManager.isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      playerManager.playNext();
                    },
                    icon: const Icon(Icons.skip_next, size: 40, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Additional Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      // Implement shuffle functionality
                    },
                    icon: const Icon(Icons.shuffle, color: Colors.white70),
                  ),
                  IconButton(
                    onPressed: () {
                      // Implement repeat functionality
                    },
                    icon: const Icon(Icons.repeat, color: Colors.white70),
                  ),
                  IconButton(
                    onPressed: () {
                      // Implement favorites functionality
                    },
                    icon: const Icon(Icons.favorite_border, color: Colors.white70),
                  ),
                  IconButton(
                    onPressed: () {
                      // Implement playlist functionality
                    },
                    icon: const Icon(Icons.playlist_add, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Mini player for bottom of other screens
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerManager>(
      builder: (context, playerManager, child) {
        if (playerManager.currentTitle == null) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 70,
          color: Colors.black87,
          child: Row(
            children: [
              // Album Art
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: playerManager.currentImage != null
                      ? Image.asset(playerManager.currentImage!, fit: BoxFit.cover)
                      : Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.music_note, color: Colors.white54),
                  ),
                ),
              ),

              // Song Info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerManager.currentTitle!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      playerManager.currentArtist ?? 'Unknown Artist',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Controls
              IconButton(
                onPressed: () {
                  if (playerManager.isPlaying) {
                    playerManager.pause();
                  } else {
                    playerManager.resume();
                  }
                },
                icon: Icon(
                  playerManager.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  playerManager.playNext();
                },
                icon: const Icon(Icons.skip_next, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Helper widget for rounded corners
class ClipRRectButton extends StatelessWidget {
  final BorderRadius borderRadius;
  final Widget child;

  const ClipRRectButton({
    Key? key,
    required this.borderRadius,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: child,
    );
  }
}