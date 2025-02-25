import 'package:alpha_tunze/exports.dart';

// import 'home.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds, then navigate to HomeScreen
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => GetStartedScreen()),
      );
    });
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
            // Image.asset('assets/alphatunz.png', width: 150), // Add your logo in assets folder
            SizedBox(height: 20),


          ],
        ),
      ),
    );
  }
}


