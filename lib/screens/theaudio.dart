// import 'package:just_audio/just_audio.dart';
//
// import '../exports.dart';
//
// class AudioPlayerScreen extends StatefulWidget {
//   @override
//   _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
// }
//
// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//
//   void _playAudio() async {
//
//     await _audioPlayer.play(AssetSource('audio/sample.mp3'));
//     setState(() {
//       isPlaying = true;
//     });
//   }
//
//   void _pauseAudio() async {
//     await _audioPlayer.pause();
//     setState(() {
//       isPlaying = false;
//     });
//   }
//
//   void _stopAudio() async {
//     await _audioPlayer.stop();
//     setState(() {
//       isPlaying = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Audio Player")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isPlaying ? Icons.music_note : Icons.music_off,
//               size: 100,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: isPlaying ? _pauseAudio : _playAudio,
//               child: Text(isPlaying ? "Pause" : "Play"),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _stopAudio,
//               child: Text("Stop"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
