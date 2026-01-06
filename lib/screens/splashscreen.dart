import 'package:alpha_tunze/exports.dart';
import '../authentication/auth.dart';
import 'Navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Show splash for at least 3 seconds (your original timing)
    await Future.delayed(Duration(seconds: 3));

    // Check if user is already logged in
    final isLoggedIn = await AuthService.isLoggedIn();

    if (mounted) {
      if (isLoggedIn) {
        // User is logged in, go directly to main app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => NavigationScreen()),
        );
      } else {
        // User is not logged in, go to get started screen (your original flow)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GetStartedScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('assets/logoapha.png', width: 200),
            ),
            SizedBox(height: 20),
            // Optional: Add a subtle loading indicator
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
