import 'package:flutter/material.dart';
import 'package:myapp/widgets/paginated_user_list.dart';
import 'package:myapp/widgets/profile_button.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/user_list_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: const [
          ProfileButton(),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<UserListProvider>(context, listen: false).fetchUsers(context, 1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: PaginatedUserList(),
            );
          }
        },
      ),
    );
  }
}
