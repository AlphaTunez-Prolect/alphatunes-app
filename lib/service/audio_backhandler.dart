import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class AudioPlayerHandler extends BaseAudioHandler {
  static AudioPlayerHandler? _instance;

  static AudioPlayerHandler get instance {
    _instance ??= AudioPlayerHandler._();
    return _instance!;
  }

  AudioPlayerHandler._();

  final AudioPlayer _player = AudioPlayer();
  List<MediaItem> _queue = [];
  int _currentIndex = 0;
  bool _initialized = false;

  // Initialize the audio handler
  Future<void> initializeAudioHandler() async {
    if (_initialized) return;

    try {
      print('Initializing AudioPlayerHandler...');

      // Listen to player state changes
      _player.playerStateStream.listen((state) {
        _updatePlaybackState(state);
      }, onError: (error) {
        print('PlayerState stream error: $error');
      });

      // Listen to position changes
      _player.positionStream.listen((position) {
        final state = playbackState.value;
        playbackState.add(state.copyWith(updatePosition: position));
      }, onError: (error) {
        print('Position stream error: $error');
      });

      // Listen to buffered position changes
      _player.bufferedPositionStream.listen((bufferedPosition) {
        final state = playbackState.value;
        playbackState.add(state.copyWith(bufferedPosition: bufferedPosition));
      }, onError: (error) {
        print('Buffered position stream error: $error');
      });

      // Listen to sequence state changes
      _player.sequenceStateStream.listen((sequenceState) {
        if (sequenceState != null && _queue.isNotEmpty) {
          _currentIndex = sequenceState.currentIndex ?? 0;
          if (_currentIndex < _queue.length) {
            mediaItem.add(_queue[_currentIndex]);
          }
        }
      }, onError: (error) {
        print('Sequence state stream error: $error');
      });

      // Handle completion - auto next
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (_currentIndex < _queue.length - 1) {
            skipToNext();
          } else {
            // End of queue - stop
            stop();
          }
        }
      });

      // Initialize playback state
      playbackState.add(PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: AudioProcessingState.idle,
        playing: false,
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,
        speed: 1.0,
        queueIndex: 0,
      ));

      _initialized = true;
      print('AudioPlayerHandler initialized successfully');


    } catch (e) {
      print('Error initializing AudioPlayerHandler: $e');
      throw e;
    }
  }

  void _updatePlaybackState(PlayerState state) {
    final isPlaying = state.playing;
    final processingState = const {
      ProcessingState.idle: AudioProcessingState.idle,
      ProcessingState.loading: AudioProcessingState.loading,
      ProcessingState.buffering: AudioProcessingState.buffering,
      ProcessingState.ready: AudioProcessingState.ready,
      ProcessingState.completed: AudioProcessingState.completed,
    }[state.processingState]!;

    playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (isPlaying) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: processingState,
      playing: isPlaying,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: _currentIndex,
    ));
  }

  @override
  Future<void> play() async {
    try {
      await _player.play();
    } catch (e) {
      print('Error playing: $e');
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print('Error pausing: $e');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
      playbackState.add(PlaybackState(
        controls: [
          MediaControl.play,
        ],
        processingState: AudioProcessingState.idle,
        playing: false,
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,
        speed: 1.0,
        queueIndex: 0,
      ));
      mediaItem.add(null);
    } catch (e) {
      print('Error stopping: $e');
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  @override
  Future<void> skipToNext() async {
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      await _setCurrentSong();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await _setCurrentSong();
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < _queue.length) {
      _currentIndex = index;
      await _setCurrentSong();
    }
  }

  Future<void> setQueue(List<MediaItem> newQueue) async {
    try {
      _queue = newQueue;
      queue.add(_queue);
      if (_queue.isNotEmpty) {
        _currentIndex = 0;
        await _setCurrentSong();
      }
    } catch (e) {
      print('Error setting queue: $e');
    }
  }

  Future<void> playFromAsset(String assetPath, MediaItem mediaItem) async {
    try {
      _queue = [mediaItem];
      queue.add(_queue);
      _currentIndex = 0;

      await _player.setAudioSource(AudioSource.asset(
        assetPath,
        tag: mediaItem,
      ));

      this.mediaItem.add(mediaItem);
      await play();
    } catch (e) {
      print('Error playing from asset: $e');
      throw e;
    }
  }

  Future<void> _setCurrentSong() async {
    try {
      if (_currentIndex >= 0 && _currentIndex < _queue.length) {
        final mediaItem = _queue[_currentIndex];

        // Get asset path from mediaItem extras
        final assetPath = mediaItem.extras?['assetPath'] as String? ?? mediaItem.id;

        if (assetPath.isNotEmpty) {
          await _player.setAudioSource(AudioSource.asset(
            assetPath,
            tag: mediaItem,
          ));

          this.mediaItem.add(mediaItem);
          await play();
        } else {
          print('No asset path found for media item: ${mediaItem.id}');
        }
      }
    } catch (e) {
      print('Error setting current song: $e');
    }
  }

  // Getters for streams
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;

  // Get current player instance for advanced operations
  AudioPlayer get audioPlayer => _player;

  // Cleanup
  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'dispose':
        await _player.dispose();
        break;
      default:
        super.customAction(name, extras);
    }
  }

  // Check if initialized
  bool get isInitialized => _initialized;
}