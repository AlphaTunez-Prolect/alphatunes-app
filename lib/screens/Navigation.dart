import 'package:alpha_tunze/exports.dart';
import 'package:alpha_tunze/screens/smartmix.dart';

import 'explore.dart';
import 'home.dart'; // Import your exports file

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    SmartMixScreen(),
    PageScreen(title: "Library"),
    PageScreen(title: "Profile"),
  ];

  final List<String> _iconPaths = [
    AppImages.HomeLogo,
    AppImages.ExploreLogo,
    AppImages.SmartMixLogo,
    AppImages.LibraryLogo,
    AppImages.ProfileLogo,
  ];

  final List<String> _labels = ["Home", "Explore", "SmartMix", "Library", "Profile"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensure all items are visible
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: List.generate(_iconPaths.length, (index) {
          return BottomNavigationBarItem(
            icon: Image.asset(
              _iconPaths[index],
              width: 24,
              height: 24,
              color: _selectedIndex == index ? Colors.white : Colors.grey,
            ),
            label: _labels[index],
          );
        }),
      ),
    );
  }
}

class PageScreen extends StatelessWidget {
  final String title;

  const PageScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$title Screen",
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}