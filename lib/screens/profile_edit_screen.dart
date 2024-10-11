import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Save changes
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage:
                  AssetImage('assets/profile.png'), // Replace with actual image
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
                                onTap: () {},
                                child: const ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("From gallery"),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: const ListTile(
                                  leading: Icon(Icons.camera_alt),
                                  title: Text("From camera"),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text("Change profile picture")),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'About'),
            ),
            const SizedBox(height: 16),
            // Add more fields as needed (e.g., phone number, email)
          ],
        ),
      ),
    );
  }
}
