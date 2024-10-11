import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/profile_edit_provider.dart';
import 'package:myapp/providers/session_provider.dart';
import 'package:myapp/models/user_model.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<SessionProvider>(context).user;

    final TextEditingController nameController =
        TextEditingController(text: user.fullname);
    final TextEditingController bioController =
        TextEditingController(text: user.bio);

    return ChangeNotifierProvider(
      create: (context) => ProfileEditProvider(),
      child: Consumer<ProfileEditProvider>(
        builder: (context, profileEditProvider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    profileEditProvider.updateProfile(
                      context,
                      user,
                      nameController.text.trim(),
                      bioController.text.trim(),
                    );
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
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
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
                  const SizedBox(height: 16),
                  if (profileEditProvider.isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
