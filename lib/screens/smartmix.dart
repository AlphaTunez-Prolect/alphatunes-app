import 'package:flutter/material.dart';

class SmartMixScreen extends StatelessWidget {
  final List<Map<String, String>> moods = [
    {"title": "Happy", "image": "assets/images/happy.jpg"},
    {"title": "Sleep", "image": "assets/images/sleep.jpg"},
    {"title": "Sad", "image": "assets/images/sad.jpg"},
    {"title": "Workout", "image": "assets/images/workout.jpg"},
    {"title": "Pray", "image": "assets/images/pray.jpg"},
    {"title": "Party", "image": "assets/images/party.jpg"},
    {"title": "Enroute", "image": "assets/images/enroute.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// SmartMix Title
              Text(
                "SmartMix",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              /// Description
              Text(
                "Elevate your mood with our AI EmotionSync function, which intuitively selects tracks based on your emotions, ensuring your playlist resonates with every feeling. Let the music mirror your mood seamlessly, creating a personalized listening experience that evolves with you, only with our EmotionSync-powered playlists.",
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              SizedBox(height: 20),

              /// Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "How do you feel?",
                    hintStyle: TextStyle(color: Colors.white60),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    suffixIcon: Icon(Icons.mic, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              /// Moods Title
              Text(
                "Moods",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              /// Mood Grid
              Expanded(
                child: GridView.builder(
                  itemCount: moods.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          /// Background Image
                          Image.asset(
                            moods[index]["image"]!,
                            fit: BoxFit.cover,
                          ),

                          /// Overlay Effect
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),

                          /// Mood Title
                          Center(
                            child: Text(
                              moods[index]["title"]!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
