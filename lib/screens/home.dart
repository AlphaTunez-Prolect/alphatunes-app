import '../exports.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> trendingAlbums = [
    {"title": "Scenery of Time", "artist": "Paul Paul", "image": AppImages.album1},
    {"title": "Scenery of Time", "artist": "Paul Paul", "image": AppImages.album2},
  ];

  final List<Map<String, String>> newReleases = [
    {"title": "Scenery of Time", "artist": "Paul Paul", "image": AppImages.album3},
    {"title": "Scenery of Time", "artist": "Paul Paul", "image": AppImages.album4},
  ];

  final List<Map<String, String>> recentlyPlayed = [
    {"title": "Emperor Of The Universe", "artist": "Dunsin Oyekan, Theophilus Sunday", "image": AppImages.song1},
    {"title": "Jehovah Shammah", "artist": "Nathaniel Bassey, Chioma Jesus", "image": AppImages.song2},
    {"title": "Wonder", "artist": "Mercy Chinwo", "image": AppImages.song3},
    {"title": "I Came By Prayer", "artist": "Theophilus Sunday", "image": AppImages.song4},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good morning",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),

                    /// Trending Albums Section
                    sectionTitle("Trending Albums For You"),
                    gridViewSection(trendingAlbums),

                    /// New Releases Section
                    sectionTitle("New releases"),
                    gridViewSection(newReleases),

                    /// Recently Played Section
                    sectionTitle("Recently Played"),
                    recentlyPlayedSection(),

                    sectionTitle("Trending Albums For You"),
                    gridViewSection(trendingAlbums),
                  ],
                ),
              ),
            ),

            /// Static Now Playing Bar
            nowPlayingBar(),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget gridViewSection(List<Map<String, String>> items) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(), // Prevents internal scrolling
      shrinkWrap: true, // Allows it to scroll inside SingleChildScrollView
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(items[index]["image"]!, fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            SizedBox(height: 5),
            Text(items[index]["title"]!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(items[index]["artist"]!, style: TextStyle(color: Colors.white60, fontSize: 12)),
          ],
        );
      },
    );
  }

  Widget recentlyPlayedSection() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(), // Prevents internal scrolling
      shrinkWrap: true, // Allows it to scroll inside SingleChildScrollView
      itemCount: recentlyPlayed.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(recentlyPlayed[index]["image"]!, fit: BoxFit.cover, width: 50, height: 50),
          ),
          title: Text(recentlyPlayed[index]["title"]!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(recentlyPlayed[index]["artist"]!, style: TextStyle(color: Colors.white60, fontSize: 12)),
          trailing: Icon(Icons.more_vert, color: Colors.white),
        );
      },
    );
  }

  Widget nowPlayingBar() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(AppImages.song4, fit: BoxFit.cover, width: 50, height: 50),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("I Came By Prayer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("Theophilus Sunday", style: TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
          Spacer(),
          Icon(Icons.skip_previous, color: Colors.white, size: 30),
          Icon(Icons.play_arrow, color: Colors.white, size: 30),
          Icon(Icons.skip_next, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}
