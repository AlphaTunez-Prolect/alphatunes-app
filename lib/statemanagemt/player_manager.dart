import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import '../service/audio_backhandler.dart'; // Your AudioPlayerHandler

class PlayerManager extends ChangeNotifier {
  static PlayerManager? _instance;
  static PlayerManager get instance => _instance ??= PlayerManager._internal();

  PlayerManager._internal();

  late final AudioPlayerHandler _audioHandler;
  bool _initialized = false;

  // ===== State =====
  String? currentTitle;
  String? currentArtist;
  String? currentImage;
  int currentSongIndex = -1;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  List<Map<String, String>> currentPlaylist = [];

  // Stream subscriptions for cleanup
  final List<StreamSubscription> _subscriptions = [];

  // Initialize the player manager
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      print('Initializing PlayerManager...');

      _audioHandler = AudioPlayerHandler.instance;
      await _audioHandler.initializeAudioHandler();

      _setupListeners();
      _initialized = true;

      print('PlayerManager initialized successfully');
    } catch (e) {
      print('Error initializing PlayerManager: $e');
      // Continue without audio service
      _initialized = true;
    }
  }

  void _setupListeners() {
    try {
      // Listen to playback state changes
      _subscriptions.add(_audioHandler.playbackState.listen((state) {
        isPlaying = state.playing;
        notifyListeners();
      }, onError: (error) {
        print('Playback state stream error: $error');
      }));

      // Listen to current media item changes
      _subscriptions.add(_audioHandler.mediaItem.listen((mediaItem) {
        if (mediaItem != null) {
          currentTitle = mediaItem.title;
          currentArtist = mediaItem.artist;
          currentImage = mediaItem.artUri?.toString();
          notifyListeners();
        }
      }, onError: (error) {
        print('Media item stream error: $error');
      }));

      // Listen to position changes
      _subscriptions.add(_audioHandler.positionStream.listen((position) {
        currentPosition = position;
        notifyListeners();
      }, onError: (error) {
        print('Position stream error: $error');
      }));

      // Listen to duration changes
      _subscriptions.add(_audioHandler.durationStream.listen((duration) {
        if (duration != null) {
          totalDuration = duration;
          notifyListeners();
        }
      }, onError: (error) {
        print('Duration stream error: $error');
      }));

      // Listen to player state changes
      _subscriptions.add(_audioHandler.playerStateStream.listen((state) {
        isPlaying = state.playing;

        // Handle completion
        if (state.processingState == ProcessingState.completed) {
          _handleSongCompletion();
        }

        notifyListeners();
      }, onError: (error) {
        print('Player state stream error: $error');
      }));

    } catch (e) {
      print('Error setting up listeners: $e');
    }
  }

  void _handleSongCompletion() {
    if (currentPlaylist.isNotEmpty && currentSongIndex < currentPlaylist.length - 1) {
      // Auto-play next song
      playNext();
    } else {
      // End of playlist
      isPlaying = false;
      notifyListeners();
    }
  }

  // ===== Playback Controls =====
  Future<void> playSong(Map<String, String> song, int index, {List<Map<String, String>>? playlist}) async {
    if (!_initialized) {
      print('PlayerManager not initialized');
      return;
    }

    try {
      currentSongIndex = index;
      if (playlist != null) {
        currentPlaylist = playlist;
      }

      final mediaItem = MediaItem(
        id: song['asset'] ?? '',
        title: song['title'] ?? 'Unknown Title',
        artist: song['artist'] ?? 'Unknown Artist',
        duration: const Duration(minutes: 3), // TODO: get real duration
        artUri: song['image']?.isNotEmpty == true ? Uri.parse(song['image']!) : null,
        extras: {'assetPath': song['asset'] ?? ''},
      );

      // Update state immediately for UI responsiveness
      currentTitle = mediaItem.title;
      currentArtist = mediaItem.artist;
      currentImage = mediaItem.artUri?.toString();
      notifyListeners();

      await _audioHandler.playFromAsset(song['asset'] ?? '', mediaItem);

    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> playPlaylist(List<Map<String, String>> songs, int startIndex) async {
    if (!_initialized || songs.isEmpty) return;

    try {
      currentPlaylist = songs;
      currentSongIndex = startIndex.clamp(0, songs.length - 1);

      final mediaItems = songs.map((song) => MediaItem(
        id: song['asset'] ?? '',
        title: song['title'] ?? 'Unknown Title',
        artist: song['artist'] ?? 'Unknown Artist',
        duration: const Duration(minutes: 3), // TODO: get real duration
        artUri: song['image']?.isNotEmpty == true ? Uri.parse(song['image']!) : null,
        extras: {'assetPath': song['asset'] ?? ''},
      )).toList();

      await _audioHandler.setQueue(mediaItems);
      await _audioHandler.skipToQueueItem(currentSongIndex);

    } catch (e) {
      print('Error playing playlist: $e');
    }
  }

  Future<void> play() async {
    if (!_initialized) return;
    try {
      await _audioHandler.play();
    } catch (e) {
      print('Error playing: $e');
    }
  }

  Future<void> pause() async {
    if (!_initialized) return;
    try {
      await _audioHandler.pause();
    } catch (e) {
      print('Error pausing: $e');
    }
  }

  Future<void> resume() async {
    await play();
  }

  Future<void> stop() async {
    if (!_initialized) return;

    try {
      await _audioHandler.stop();

      // Reset state
      currentTitle = null;
      currentArtist = null;
      currentImage = null;
      currentSongIndex = -1;
      isPlaying = false;
      currentPosition = Duration.zero;
      totalDuration = Duration.zero;

      notifyListeners();
    } catch (e) {
      print('Error stopping: $e');
    }
  }

  Future<void> playNext() async {
    if (!_initialized) return;

    try {
      if (currentPlaylist.isNotEmpty && currentSongIndex < currentPlaylist.length - 1) {
        currentSongIndex++;
        await playSong(currentPlaylist[currentSongIndex], currentSongIndex, playlist: currentPlaylist);
      } else {
        await _audioHandler.skipToNext();
      }
    } catch (e) {
      print('Error playing next: $e');
    }
  }

  Future<void> playPrevious() async {
    if (!_initialized) return;

    try {
      if (currentPlaylist.isNotEmpty && currentSongIndex > 0) {
        currentSongIndex--;
        await playSong(currentPlaylist[currentSongIndex], currentSongIndex, playlist: currentPlaylist);
      } else {
        await _audioHandler.skipToPrevious();
      }
    } catch (e) {
      print('Error playing previous: $e');
    }
  }

  Future<void> seek(Duration position) async {
    if (!_initialized) return;

    try {
      await _audioHandler.seek(position);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  // ===== Playlist Helpers =====
  Future<void> playNextFromList(List<Map<String, String>> songs) async {
    if (currentSongIndex < 0 || songs.isEmpty) return;
    int nextIndex = (currentSongIndex + 1) % songs.length;
    await playSong(songs[nextIndex], nextIndex, playlist: songs);
  }

  Future<void> playPreviousFromList(List<Map<String, String>> songs) async {
    if (currentSongIndex < 0 || songs.isEmpty) return;
    int prevIndex = (currentSongIndex - 1 + songs.length) % songs.length;
    await playSong(songs[prevIndex], prevIndex, playlist: songs);
  }

  Future<void> shufflePlaylist() async {
    if (currentPlaylist.isEmpty) return;

    currentPlaylist.shuffle();
    await playPlaylist(currentPlaylist, 0);
  }

  // ===== Getters and Utilities =====
  String get positionText => _formatDuration(currentPosition);
  String get durationText => _formatDuration(totalDuration);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  double get progress {
    if (totalDuration.inMilliseconds <= 0) return 0.0;
    return currentPosition.inMilliseconds / totalDuration.inMilliseconds;
  }

  bool get hasPrevious => currentSongIndex > 0;
  bool get hasNext => currentSongIndex < currentPlaylist.length - 1;
  bool get hasCurrentSong => currentSongIndex >= 0 && currentTitle != null;
  bool get isInitialized => _initialized;

  // Get current song info
  Map<String, String>? get currentSong {
    if (currentSongIndex >= 0 && currentSongIndex < currentPlaylist.length) {
      return currentPlaylist[currentSongIndex];
    }
    return null;
  }

  @override
  void dispose() {
    print('Disposing PlayerManager...');

    // Cancel all subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Clean up audio handler
    if (_initialized) {
      _audioHandler.customAction('dispose');
    }

    super.dispose();
  }
}