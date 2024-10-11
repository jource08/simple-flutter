import 'package:flutter/material.dart';
import 'package:myapp/models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username ?? "User Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Center(
              child: ClipOval(
                child: user.profileImageUrl != null
                    ? Image.network(
                        user.profileImageUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) {
                            return child;
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, size: 120);
                        },
                      )
                    : const Icon(Icons.person, size: 120),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              user.fullname ?? "No Name",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user.email ?? "No Email",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bio:',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user.bio ?? "No bio available",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
