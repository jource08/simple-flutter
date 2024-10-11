import 'package:flutter/material.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/session_provider.dart';
import 'package:myapp/models/user_model.dart';
import 'package:dio/dio.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  Future<void> _updateProfile(BuildContext context, User user, String name, String bio) async {
    final dio = Dio();
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    String authCookie = sessionProvider.authCookie;  // Get the cookie from SessionProvider

    try {
      final updatedUser = {
        'username': user.username,
        'email': user.email,
        'fullname': name,
        'bio': bio,
        'profile_image_url': user.profileImageUrl,
      };

      final response = await dio.put(
        "${AppConst.listUserUrl}/${user.id}", 
        data: updatedUser,
        options: Options(
          headers: {
            'Cookie': authCookie,
          },
        ),
      );

      if (response.statusCode == 200) {
        sessionProvider.setUser(user.copyWith(fullname: name, bio: bio));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated successfully!")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update profile")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error occurred")));
      rethrow; // Rethrow for error handling if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<SessionProvider>(context).user;

    final TextEditingController nameController =
        TextEditingController(text: user?.fullname);
    final TextEditingController bioController =
        TextEditingController(text: user?.bio);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (user != null) {
                _updateProfile(
                  context,
                  user,
                  nameController.text.trim(),
                  bioController.text.trim(),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                // TODO: Implement gallery image picker
                              },
                              child: const ListTile(
                                leading: Icon(Icons.image),
                                title: Text("From gallery"),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // TODO: Implement camera image picker
                              },
                              child: const ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text("From camera"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text("Change profile picture"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: 'About'),
            ),
          ],
        ),
      ),
    );
  }
}
