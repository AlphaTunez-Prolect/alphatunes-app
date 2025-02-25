import '../../exports.dart';

class ProfileCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String followers;
  final bool isFollowing;
  final String followText;
  final String followingText;
  final Color followColor;
  final Color followingColor;
  final Color followTextColor;
  final Color followingTextColor;

  const ProfileCard({
    super.key,
    required this.profileImage,
    required this.name,
    required this.followers,
    required this.isFollowing,
    this.followText = "Follow",
    this.followingText = "Following",
    this.followColor = Colors.blue,
    this.followingColor = Colors.pink,
    this.followTextColor = Colors.white,
    this.followingTextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Image
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(profileImage),
        ),
        const SizedBox(width: 10),

        // Name & Followers
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              followers,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        const Spacer(),

        // Follow Button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing ? followingColor : followColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          ),
          child: Text(
            isFollowing ? followingText : followText,
            style: TextStyle(
              color: isFollowing ? followingTextColor : followTextColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
