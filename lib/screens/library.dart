import 'package:alpha_tunze/exports.dart';
import 'package:flutter/material.dart';

// Main Library Screen
class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    _pulseController.repeat(reverse: true);

    Future.delayed(Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Original Library content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Library", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryButton(label: "All", isActive: true),
                      CategoryButton(label: "Artists"),
                      CategoryButton(label: "Playlists"),
                      CategoryButton(label: "Podcasts"),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Recent", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      RecentItem(title: "The Love of the Father", subtitle: "Heidi Klum · Podcast", image: AppImages.album1),
                      RecentItem(title: "Dealing With Inferiority Complex", subtitle: "Rachel Sunders · Podcast", image: AppImages.album2),
                      RecentItem(title: "Peaceful Meditation", subtitle: "Playlist", image: AppImages.album3),
                      SizedBox(height: 10),
                      LibraryItem(title: "New Episodes", subtitle: "Last Updated Feb 21, 2024", icon: Icons.favorite, color: Colors.blue),
                      LibraryItem(title: "Your Playlists", subtitle: "Playlist · 500 songs", icon: Icons.playlist_play, color: Colors.green),
                      LibraryItem(title: "Downloads", subtitle: "Saved and Downloaded Songs and Podcasts", icon: Icons.download, color: Colors.yellow),
                      LibraryItem(title: "Liked Songs", subtitle: "Playlist · 500 songs", icon: Icons.favorite, color: Colors.pink),
                    ],
                  ),
                ),
                BottomMusicPlayer(),
              ],
            ),
          ),

          // Coming Soon Overlay with animations
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Container(
                color: Colors.black.withOpacity(_fadeAnimation.value),
                child: Center(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated icon
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.library_music,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 32),

                        // Coming Soon text with shimmer effect
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.5),
                                  Colors.white,
                                  Colors.white.withOpacity(0.5),
                                ],
                                stops: [
                                  0.0,
                                  _pulseController.value,
                                  1.0,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                "Coming Soon",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 16),

                        // Subtitle
                        Text(
                          "Enhanced Library Features are being developed!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 8),

                        // Animated dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                double delay = index * 0.2;
                                double animValue = (_pulseController.value + delay) % 1.0;

                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  child: Transform.translate(
                                    offset: Offset(0, -10 * (animValue < 0.5 ? animValue * 2 : (1 - animValue) * 2)),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ),

                        SizedBox(height: 40),

                        // Close button
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Go Back",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Reusable Category Button
class CategoryButton extends StatelessWidget {
  final String label;
  final bool isActive;

  const CategoryButton({required this.label, this.isActive = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.pinkAccent : Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Reusable List Tile for Recent Items
class RecentItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const RecentItem({required this.title, required this.subtitle, required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.more_horiz, color: Colors.white60),
        ],
      ),
    );
  }
}

// Reusable Library Item
class LibraryItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const LibraryItem({required this.title, required this.subtitle, required this.icon, required this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white60, fontSize: 12)),
    );
  }
}

// Bottom Music Player
class BottomMusicPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border(top: BorderSide(color: Colors.white24, width: 0.5)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(AppImages.album1, width: 40, height: 40, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("I Came By Prayer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("Theophilus Sunday", style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.skip_previous, color: Colors.white),
          SizedBox(width: 10),
          Icon(Icons.pause_circle_filled, color: Colors.white, size: 32),
          SizedBox(width: 10),
          Icon(Icons.skip_next, color: Colors.white),
        ],
      ),
    );
  }
}