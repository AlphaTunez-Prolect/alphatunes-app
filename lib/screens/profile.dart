import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _firstName = 'Guest';
  String _lastName = 'User';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('user_first_name') ?? 'Guest';
      _lastName = prefs.getString('user_last_name') ?? 'User';
      _email = prefs.getString('user_email') ?? '';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      final response = await http.post(
        Uri.parse('https://openauthzero.myf2.net/openauthzero/user/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // remove if not needed
        },
      );

      if (response.statusCode == 200) {
        await prefs.clear(); // Clear all user data
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        final body = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? 'Logout failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeader(
              firstName: _firstName,
              lastName: _lastName,
              email: _email,
            ),
            Expanded(
              child: ListView(
                children: const [
                  ProfileOption(icon: Icons.person, title: 'Account'),
                  ProfileOption(icon: Icons.download, title: 'Download'),
                  ProfileOption(icon: Icons.security, title: 'Security and Privacy'),
                  ProfileOption(icon: Icons.info, title: 'About Us'),
                  ProfileOption(icon: Icons.help, title: 'Help Center'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Log out', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;

  const ProfileHeader({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(AppImages.album1), // Replace with actual image
          child: firstName.isNotEmpty ?
          Text(
            '${firstName[0].toUpperCase()}${lastName.isNotEmpty ? lastName[0].toUpperCase() : ''}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ) : null,
        ),
        const SizedBox(height: 10),
        Text(
          '$firstName $lastName',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        if (email.isNotEmpty)
          Text(
            email,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        const Text('Free account', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
          child: const Text('Get Premium', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileOption({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: () {},
    );
  }
}