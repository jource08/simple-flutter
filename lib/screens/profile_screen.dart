import 'package:flutter/material.dart';
import 'package:myapp/screens/profile_edit_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/session_provider.dart';
import 'package:myapp/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access user from SessionProvider
    final User? user = Provider.of<SessionProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.profileImageUrl != null
                  ? NetworkImage(user!.profileImageUrl!)
                  : null,
              child: user?.profileImageUrl == null
                  ? const Icon(
                      Icons.person,
                      size: 50,
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              user?.fullname ?? 'Your Name',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              user?.bio ?? 'Your About', // Show the bio or a default value
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProfileEditScreen()));
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
