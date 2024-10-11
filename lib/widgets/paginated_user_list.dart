import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/user_list_provider.dart';

class PaginatedUserList extends StatelessWidget {
  const PaginatedUserList({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserListProvider>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: userProvider.users.length,
            itemBuilder: (context, index) {
              final user = userProvider.users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.profileImageUrl != null
                      ? NetworkImage(user.profileImageUrl!)
                      : null,
                  child: user.profileImageUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(user.fullname ?? ""),
                subtitle: Text(user.email ?? ""),
                trailing: const Icon(Icons.arrow_forward),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: userProvider.currentPage > 1
                  ? () {
                      userProvider.changePage(
                          context, userProvider.currentPage - 1);
                    }
                  : null,
              child: const Text('Previous'),
            ),
            Text(
                'Page ${userProvider.currentPage} of ${userProvider.totalPages}'),
            TextButton(
              onPressed: userProvider.currentPage < userProvider.totalPages
                  ? () {
                      userProvider.changePage(
                          context, userProvider.currentPage + 1);
                    }
                  : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
