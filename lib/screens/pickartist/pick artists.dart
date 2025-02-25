import 'package:alpha_tunze/exports.dart';
import 'package:alpha_tunze/screens/pickartist/profilecard.dart';

import '../../widgets/skipbutton.dart';
import '../Navigation.dart';
import '../home.dart';


class PickArtistsScreen extends StatelessWidget {
  const PickArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,), // Left arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: Center(
          child: Text('Choose Top Artists',  style: TextStyle(
            color: Colors.white
          ) ,)
        ),
        actions: [
          // Add additional actions if needed
          const SizedBox(width: 48), // Add spacing to balance the title
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [

            Row(
              children: [
                Text('Select 5 or more of your favourite artists',
                  style: TextStyle(
                  color: Colors.white,

                ),),
              ],
            ),
SizedBox(height: 20,),
            ProfileCard(
              profileImage: AppImages.AppLogo,
              name: "Dunsin Oyekan",
              followers: "50K Followers",
              isFollowing: false,
              followColor: Colors.pink,   // Custom color when not following
              followingColor: Colors.red,

              // Custom color when following
            ),

            ProfileCard(
              profileImage: 'assets/user1.jpg',
              name: "Nathaniel Bassey",
              followers: "50K Followers",
              isFollowing: false,
              followColor: Colors.white,   // Custom color when not following
              followingColor: Colors.red,

              // Custom color when following
            ),



            ProfileCard(
              profileImage: 'assets/user1.jpg',
              name: "John Doe",
              followers: "50K Followers",
              isFollowing: false,
              followText: "Add Friend",
              followingText: "Friend",
              followColor: Colors.green,
              followingColor: Colors.red,
              followTextColor: Colors.black,  // Custom text color when not following
              followingTextColor: Colors.yellow, // Custom text color when following
            ),

            ProfileCard(
              profileImage: 'assets/user1.jpg',
              name: "Nathaniel Bassey",
              followers: "50K Followers",
              isFollowing: false,
              followText: "Folllow",
              followingText: "Friend",
              followColor: Colors.pink,
              followingColor: Colors.red,
              followTextColor: Colors.white,  // Custom text color when not following
              followingTextColor: Colors.yellow, // Custom text color when following
            ),

            Spacer(),
            SkipContinueButtons(
              onSkip: () {
                print("Skip button pressed");
              },
              onContinue: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  NavigationScreen()),
                );
                // print("Continue button pressed");
              },
            ),

            SizedBox(height: 10,)


          ],
        ),
      ),
    );
  }
}



//
// appBar: AppBar(
// backgroundColor: Colors.black,
// leading: IconButton(
// icon: const Icon(Icons.arrow_back, color: Colors.white,), // Left arrow icon
// onPressed: () {
// Navigator.pop(context); // Navigate back
// },
// ),
// title: Center(
// child: Image.asset(
// AppImages.AppLogo, // Path to your image
// height: 150, // Adjust height as needed
// width: 150,
// fit: BoxFit.contain, // Ensure the image fits well
// ),
// ),
// actions: [
// // Add additional actions if needed
// const SizedBox(width: 48), // Add spacing to balance the title
// ],
// ),