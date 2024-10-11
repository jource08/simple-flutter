import 'package:flutter/material.dart';
import 'package:myapp/providers/user_list_provider.dart';
import 'package:provider/provider.dart';

class PaginatedUserList extends StatelessWidget {
  const PaginatedUserList({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    // Trigger a refresh by re-fetching the data
    await Provider.of<UserListProvider>(context, listen: false).fetchUsers(context, 1);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserListProvider>(context);

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: ListView.builder(
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                final user = userProvider.users[index];
                return ListTile(
                  leading: ClipOval(
                    child: user.profileImageUrl != null
                        ? Image.network(
                            user.profileImageUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) {
                                return child;
                              } else {
                                return const Icon(Icons.person, size: 40); // Placeholder while loading
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 40); // Error icon
                            },
                          )
                        : const Icon(Icons.person, size: 40), // Default icon if no profile image
                  ),
                  title: Text(user.fullname ?? ""),
                  subtitle: Text(user.email ?? ""),
                  trailing: const Icon(Icons.arrow_forward),
                );
              },
            ),
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
