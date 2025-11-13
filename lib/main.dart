// Simplified main.dart - with just_audio_background enabled
import 'package:alpha_tunze/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'Theme/theme.dart';
import 'Theme/theme_provider.dart';
import 'Theme/themeviewmodel/theme_viewmodel.dart';
import 'statemanagemt/player_manager.dart';

// ✅ Re-enable just_audio_background
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize background audio (enables Now Playing notification + lockscreen)
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.alpha_tunze.audio',
    androidNotificationChannelName: 'Alpha Tunze Playback',
    androidNotificationOngoing: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  String _initializationStatus = 'Initializing app...';

  @override
  void initState() {
    super.initState();
    // ✅ Run initialization after first frame to avoid blocking UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeServices();
    });
  }

  Future<void> _initializeServices() async {
    try {
      print('Starting service initialization...');

      setState(() {
        _initializationStatus = 'Initializing player manager...';
      });

      // ✅ Ensure PlayerManager initializes only once
      print('Initializing PlayerManager...');
      await PlayerManager.instance.initialize();
      print('PlayerManager initialized successfully');

      setState(() {
        _isInitialized = true;
      });

      print('App initialization completed successfully');
    } catch (e, stackTrace) {
      print('Initialization error: $e');
      print('Stack trace: $stackTrace');

      // Continue anyway
      setState(() {
        _isInitialized = true;
        _initializationStatus = 'Initialization completed with warnings';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  _initializationStatus,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider.value(value: PlayerManager.instance),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeProvider.themeData,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
