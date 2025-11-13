import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlbumScreen extends StatefulWidget {
  final String title;
  final String artist;
  final String image;

  const AlbumScreen({
    super.key,
    required this.title,
    required this.artist,
    required this.image,
  });

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  bool isLiked = false;
  bool isShuffleOn = false;
  int currentlyPlaying = -1;

  final List<AlbumTrack> tracks = [
    AlbumTrack(title: 'You Make Me Brave', artist: 'Bethel Music, Amanda Lindsey-Cook'),
    AlbumTrack(title: 'It Is Well', artist: 'Bethel Music, Amanda Lindsey-Cook'),
    AlbumTrack(title: 'Wonder', artist: 'Mercy Chinwo'),
    AlbumTrack(title: 'I Came By Prayer', artist: 'Theophilus Sunday'),
  ];

  final List<RelatedAlbum> relatedAlbums = [
    RelatedAlbum(
      title: 'Have It All (Live)',
      subtitle: 'Album • 2014',
      imageUrl: 'https://via.placeholder.com/120x120/D4AF37/FFFFFF?text=HIA',
    ),
    RelatedAlbum(
      title: 'Starlight',
      subtitle: 'Album • 2023',
      imageUrl: 'https://via.placeholder.com/120x120/1E3A8A/FFFFFF?text=SL',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Hero section with album art
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroSection(),
            ),
          ),

          // Album info and controls
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAlbumInfo(),
                  const SizedBox(height: 20),
                  _buildAlbumControls(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Track list
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildTrackTile(tracks[index], index),
                );
              },
              childCount: tracks.length,
            ),
          ),

          // More by artist section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildRelatedAlbumsGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.image), // 👈 dynamic image
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.artist.toUpperCase(),
                    style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Text(widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(widget.artist, style: const TextStyle(color: Colors.white60, fontSize: 16)),
      ],
    );
  }

  Widget _buildAlbumControls() {
    return Row(
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
            decoration: const BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
            child: Icon(
              currentlyPlaying != -1 ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 20),

        // Shuffle
        GestureDetector(
          onTap: () {
            setState(() {
              isShuffleOn = !isShuffleOn;
            });
            HapticFeedback.lightImpact();
          },
          child: Icon(Icons.shuffle, color: isShuffleOn ? Colors.pink : Colors.white60, size: 24),
        ),

        const Spacer(),

        // Like
        GestureDetector(
          onTap: () {
            setState(() {
              isLiked = !isLiked;
            });
            HapticFeedback.lightImpact();
          },
          child: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.pink : Colors.white60, size: 24),
        ),
      ],
    );
  }

  Widget _buildTrackTile(AlbumTrack track, int index) {
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
            SizedBox(
              width: 30,
              child: Center(
                child: isCurrentlyPlaying
                    ? const Icon(Icons.pause, color: Colors.pink, size: 20)
                    : Text('${index + 1}', style: const TextStyle(color: Colors.white60, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(track.title,
                      style: TextStyle(
                        color: isCurrentlyPlaying ? Colors.pink : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(height: 2),
                  Text(track.artist,
                      style: TextStyle(
                        color: isCurrentlyPlaying ? Colors.pink.withOpacity(0.8) : Colors.white60,
                        fontSize: 14,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedAlbumsGrid() {
    final List<Map<String, String>> albumItems = relatedAlbums.map((album) {
      return {
        'title': album.title,
        'artist': album.subtitle,
        'image': album.imageUrl,
      };
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("More by Artist",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: albumItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                // 👇 Navigate to another AlbumScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumScreen(
                      title: albumItems[index]['title']!,
                      artist: albumItems[index]['artist']!,
                      image: albumItems[index]['image']!,
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
                      child: Image.network(albumItems[index]['image']!,
                          fit: BoxFit.cover, width: double.infinity),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(albumItems[index]['title']!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(albumItems[index]['artist']!,
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class AlbumTrack {
  final String title;
  final String artist;
  AlbumTrack({required this.title, required this.artist});
}

class RelatedAlbum {
  final String title;
  final String subtitle;
  final String imageUrl;
  RelatedAlbum({required this.title, required this.subtitle, required this.imageUrl});
}
