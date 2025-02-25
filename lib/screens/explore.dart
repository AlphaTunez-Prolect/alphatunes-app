import 'package:alpha_tunze/const/images_string.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  final List<String> genres = [
    "Hip Hop", "Worship", "Rock", "RnB", "Pop", "Afro Gospel", "Classical"
  ];

  final List<Map<String, String>> songsForYou = [
    {
      "title": "Emperor Of The Universe",
      "artist": "Dunsin Oyekan, Theophilus Sunday",
      "image": AppImages.song1,
    },
    {
      "title": "Jehovah Shammah",
      "artist": "Nathaniel Bassey, Chioma Jesus",
      "image": AppImages.song2,
    },
    {
      "title": "Wonder",
      "artist": "Mercy Chinwo",
      "image": AppImages.song3,
    },
    {
      "title": "I Came By Prayer",
      "artist": "Theophilus Sunday",
      "image": AppImages.song4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              /// Explore Title
              Text(
                "Explore",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),

              /// Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search music, artist, album...",
                    hintStyle: TextStyle(color: Colors.white60),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              /// Genres Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Genres",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              ),
              SizedBox(height: 10),

              /// Genre Chips
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: genres.map((genre) {
                  return Chip(
                    label: Text(genre),
                    backgroundColor: genre == "Hip Hop" ? Colors.pinkAccent : Colors.transparent,
                    shape: StadiumBorder(side: BorderSide(color: Colors.white60)),
                    labelStyle: TextStyle(color: Colors.white),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              /// Featured Music (Today's Top Hit)
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      AppImages.album1,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 15,
                    left: 15,
                    child: Text(
                      "Today's Top Hit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 15,
                    child: Icon(Icons.play_circle_fill, color: Colors.white, size: 35),
                  ),
                ],
              ),
              SizedBox(height: 20),

              /// Songs for You Section
              Text(
                "Songs for you",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              /// Songs List
              Column(
                children: songsForYou.map((song) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        song["image"]!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      song["title"]!,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      song["artist"]!,
                      style: TextStyle(color: Colors.white60),
                    ),
                    trailing: Icon(Icons.more_vert, color: Colors.white),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
