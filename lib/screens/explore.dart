import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../const/images_string.dart';
import '../statemanagemt/player_manager.dart';
import 'nowplaying.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  // final PlayerManager _playerManager = PlayerManager();
  final PlayerManager _playerManager = PlayerManager.instance; // ✅ Correct

  String selectedGenre = 'All';
  String _searchQuery = '';
  List<Map<String, String>> _filteredSongs = [];

  final List<String> genres = [
    'All',
    'Hip Hop',
    'Worship',
    'Rock',
    'RnB',
    'Pop',
    'Afro Gospel',
    'Classical',
  ];

  // Updated songs list with audio assets, images, and genres
  final List<Map<String, String>> songsForYou = [
    {
      "title": "Emperor Of The Universe",
      "artist": "Dunsin Oyekan",
      "asset": "assets/audio/DUNSIN-OYEKAN-Emperor-of-the-Universe-(CeeNaija.com).mp3",
      "image": AppImages.song1,
      "genre": "Worship",
    },
    {
      "title": "I Came By Prayer",
      "artist": "Theophilus Sunday",
      "asset": "assets/audio/I_CAME_BY_PRAYER128k.mp3",
      "image": AppImages.song3,
      "genre": "Worship",
    },
    {
      "title": "With Joy",
      "artist": "Dunsin Oyekan",
      "asset": "assets/audio/Dunsin-Oyekan-With-Joy-(TunezJam.com).mp3",
      "image": AppImages.song2,
      "genre": "Worship",
    },
    {
      "title": "Jehovah Shammah",
      "artist": "Nathaniel Bassey",
      "asset": "assets/audio/sample1.mp3",
      "image": AppImages.song1,
      "genre": "Afro Gospel",
    },
    {
      "title": "Wonder",
      "artist": "Mercy Chinwo",
      "asset": "assets/audio/sample2.mp3",
      "image": AppImages.song2,
      "genre": "Afro Gospel",
    },
    {
      "title": "Goodness of God",
      "artist": "Bethel Music",
      "asset": "assets/audio/sample3.mp3",
      "image": AppImages.song3,
      "genre": "Worship",
    },
    {
      "title": "Way Maker",
      "artist": "Sinach",
      "asset": "assets/audio/sample4.mp3",
      "image": AppImages.album1,
      "genre": "Afro Gospel",
    },
    {
      "title": "Reckless Love",
      "artist": "Cory Asbury",
      "asset": "assets/audio/sample5.mp3",
      "image": AppImages.album2,
      "genre": "Worship",
    },
    {
      "title": "Can't Stop the Feeling",
      "artist": "Justin Timberlake",
      "asset": "assets/audio/sample6.mp3",
      "image": AppImages.album3,
      "genre": "Pop",
    },
    {
      "title": "Bohemian Rhapsody",
      "artist": "Queen",
      "asset": "assets/audio/sample7.mp3",
      "image": AppImages.album4,
      "genre": "Rock",
    },
    {
      "title": "Stay",
      "artist": "Rihanna",
      "asset": "assets/audio/sample8.mp3",
      "image": AppImages.song1,
      "genre": "RnB",
    },
    {
      "title": "God's Plan",
      "artist": "Drake",
      "asset": "assets/audio/sample9.mp3",
      "image": AppImages.song2,
      "genre": "Hip Hop",
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredSongs = List.from(songsForYou);

    // Listen to PlayerManager changes
    _playerManager.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _filterAndSortSongs() {
    setState(() {
      // Start with all songs
      List<Map<String, String>> tempSongs = List.from(songsForYou);

      // Filter by genre if a specific genre is selected
      if (selectedGenre != 'All') {
        tempSongs = tempSongs.where((song) => song['genre'] == selectedGenre).toList();
      }

      // If there's a search query, sort the results but keep all songs
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();

        // Separate matching and non-matching songs
        List<Map<String, String>> matchingSongs = [];
        List<Map<String, String>> nonMatchingSongs = [];

        for (var song in tempSongs) {
          final title = song['title']!.toLowerCase();
          final artist = song['artist']!.toLowerCase();

          if (title.contains(searchLower) || artist.contains(searchLower)) {
            matchingSongs.add(song);
          } else {
            nonMatchingSongs.add(song);
          }
        }

        // Sort matching songs to show exact matches first
        matchingSongs.sort((a, b) {
          final aTitle = a['title']!.toLowerCase();
          final bTitle = b['title']!.toLowerCase();
          final aArtist = a['artist']!.toLowerCase();
          final bArtist = b['artist']!.toLowerCase();

          // Exact title match gets highest priority
          if (aTitle.startsWith(searchLower) && !bTitle.startsWith(searchLower)) return -1;
          if (bTitle.startsWith(searchLower) && !aTitle.startsWith(searchLower)) return 1;

          // Exact artist match gets second priority
          if (aArtist.startsWith(searchLower) && !bArtist.startsWith(searchLower)) return -1;
          if (bArtist.startsWith(searchLower) && !aArtist.startsWith(searchLower)) return 1;

          return 0;
        });

        // Combine: matching songs first, then non-matching songs
        _filteredSongs = [...matchingSongs, ...nonMatchingSongs];
      } else {
        _filteredSongs = tempSongs;
      }
    });
  }

  void _filterSongs(String query) {
    _searchQuery = query;
    _filterAndSortSongs();
  }

  void _selectGenre(String genre) {
    setState(() {
      selectedGenre = genre;
    });
    _filterAndSortSongs();
  }

  Future<void> _playSong(Map<String, String> song, [int? index]) async {
    int songIndex = index ?? _filteredSongs.indexWhere((s) => s['title'] == song['title']);
    await _playerManager.playSong(song, songIndex, playlist: _filteredSongs);
  }

  Widget nowPlayingBar() {
    if (_playerManager.currentTitle == null) return SizedBox();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayerScreen(
              title: _playerManager.currentTitle!,
              artist: _playerManager.currentArtist!,
              image: _playerManager.currentImage!,
              isPlaying: _playerManager.isPlaying,
              songs: _filteredSongs,
              currentIndex: _playerManager.currentSongIndex,
              onSongChanged: (index) {
                _playSong(_filteredSongs[index], index);
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                _playerManager.currentImage!,
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
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _playerManager.currentTitle!,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _playerManager.currentArtist!,
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.skip_previous, color: Colors.white),
              onPressed: () async {
                await _playerManager.playPreviousFromList(_filteredSongs);
              },
            ),
            IconButton(
              icon: Icon(
                _playerManager.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
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
              icon: Icon(Icons.skip_next, color: Colors.white),
              onPressed: () async {
                await _playerManager.playNextFromList(_filteredSongs);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(),

                      const SizedBox(height: 24),

                      // Search bar
                      _buildSearchBar(),

                      const SizedBox(height: 32),

                      // Genres section
                      _buildGenresSection(),

                      const SizedBox(height: 32),

                      // Today's Top Hit card
                      _buildTodaysTopHit(),

                      const SizedBox(height: 32),

                      // Songs for you section
                      _buildSongsForYouSection(),
                    ],
                  ),
                ),
              ),
            ),
            nowPlayingBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Explore',
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Search music, artist, album...',
          hintStyle: TextStyle(
            color: Colors.white60,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white60,
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onSubmitted: (value) {
          HapticFeedback.lightImpact();
        },
        onChanged: (value) {
          _filterSongs(value);
        },
      ),
    );
  }

  Widget _buildGenresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Genres',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
              },
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Genre chips
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: genres.map((genre) => _buildGenreChip(genre)).toList(),
        ),
      ],
    );
  }

  Widget _buildGenreChip(String genre) {
    final bool isSelected = genre == selectedGenre;

    return GestureDetector(
      onTap: () {
        _selectGenre(genre);
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.pink : Colors.white60,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          genre,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysTopHit() {
    return GestureDetector(
      onTap: () {
        // Play the first song when top hit is tapped
        if (_filteredSongs.isNotEmpty) {
          _playSong(_filteredSongs[0], 0);
        }
        HapticFeedback.mediumImpact();
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=400&h=200&fit=crop'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Play button
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 24,
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
                    Text(
                      "Today's Top Hit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_filteredSongs.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Text(
                        _filteredSongs[0]['title']!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _filteredSongs[0]['artist']!,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongsForYouSection() {
    // Count matching songs for search results
    int matchingCount = 0;
    if (_searchQuery.isNotEmpty) {
      final searchLower = _searchQuery.toLowerCase();
      matchingCount = _filteredSongs.where((song) {
        final title = song['title']!.toLowerCase();
        final artist = song['artist']!.toLowerCase();
        return title.contains(searchLower) || artist.contains(searchLower);
      }).length;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedGenre != 'All'
                  ? '$selectedGenre Music'
                  : (_searchQuery.isEmpty ? 'Songs for you' : 'All Songs'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_searchQuery.isEmpty && selectedGenre == 'All')
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.white60,
                  size: 24,
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // Info text
        if (_searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white60, fontSize: 14),
                children: [
                  TextSpan(text: '$matchingCount matching result${matchingCount != 1 ? 's' : ''} '),
                  const TextSpan(text: '• ', style: TextStyle(color: Colors.white30)),
                  TextSpan(text: 'Showing ${_filteredSongs.length} total songs'),
                ],
              ),
            ),
          )
        else if (selectedGenre != 'All')
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              '${_filteredSongs.length} ${selectedGenre.toLowerCase()} song${_filteredSongs.length != 1 ? 's' : ''}',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
          ),

        const SizedBox(height: 8),

        // Songs list - scrollable
        Container(
          height: 400,
          child: ListView.builder(
            itemCount: _filteredSongs.length,
            itemBuilder: (context, index) {
              return _buildSongTile(_filteredSongs[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSongTile(Map<String, String> song, int index) {
    bool isCurrentSong = _playerManager.currentTitle == song['title'];

    // Check if this song matches the search query
    bool isMatchingSong = false;
    if (_searchQuery.isNotEmpty) {
      final searchLower = _searchQuery.toLowerCase();
      final title = song['title']!.toLowerCase();
      final artist = song['artist']!.toLowerCase();
      isMatchingSong = title.contains(searchLower) || artist.contains(searchLower);
    }

    return GestureDetector(
      onTap: () {
        _playSong(song, index);
        HapticFeedback.lightImpact();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isMatchingSong && _searchQuery.isNotEmpty
              ? Colors.white.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isMatchingSong && _searchQuery.isNotEmpty
              ? Border.all(color: Colors.white.withOpacity(0.1), width: 1)
              : null,
        ),
        child: Row(
          children: [
            // Album art with play indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
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
                if (isCurrentSong && _playerManager.isPlaying)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.equalizer, color: Colors.green),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          song['title']!,
                          style: TextStyle(
                            color: isCurrentSong ? Colors.green :
                            (isMatchingSong && _searchQuery.isNotEmpty ? Colors.white : Colors.white),
                            fontSize: 16,
                            fontWeight: isCurrentSong ? FontWeight.bold :
                            (isMatchingSong && _searchQuery.isNotEmpty ? FontWeight.w600 : FontWeight.w500),
                          ),
                        ),
                      ),
                      if (isMatchingSong && _searchQuery.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.blue.withOpacity(0.5), width: 1),
                          ),
                          child: Text(
                            'MATCH',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          song['artist']!,
                          style: TextStyle(
                            color: isCurrentSong ? Colors.green.shade300 : Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        song['genre']!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
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

  void _showSongOptions(Map<String, String> song) {
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          song['artist']!,
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
              _buildBottomSheetOption(Icons.play_arrow, 'Play now', () {
                int index = _filteredSongs.indexWhere((s) => s['title'] == song['title']);
                _playSong(song, index);
              }),
              _buildBottomSheetOption(Icons.queue_music, 'Add to queue', () {}),
              _buildBottomSheetOption(Icons.favorite_border, 'Like', () {}),
              _buildBottomSheetOption(Icons.playlist_add, 'Add to playlist', () {}),
              _buildBottomSheetOption(Icons.album, 'Go to album', () {}),
              _buildBottomSheetOption(Icons.person, 'Go to artist', () {}),
              _buildBottomSheetOption(Icons.share, 'Share', () {}),
              _buildBottomSheetOption(Icons.download, 'Download', () {}),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption(IconData icon, String title, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) onTap();
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