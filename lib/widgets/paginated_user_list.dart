import 'package:flutter/material.dart';
import 'package:myapp/providers/user_list_provider.dart';
import 'package:myapp/screens/user_detail_screen.dart';
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
        // Expanded ListView containing users
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: Stack(
              children: [
                // List of users
                ListView.builder(
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
                                    return const Icon(Icons.person, size: 40);
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, size: 40); 
                                },
                              )
                            : const Icon(Icons.person, size: 40),
                      ),
                      title: Text(user.fullname ?? ""),
                      subtitle: Text(user.email ?? ""),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserDetailScreen(user: user),
                          ),
                        );
                      },
                    );
                  },
                ),
                
                // Full-screen white overlay while loading
                if (userProvider.isLoading)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.8, // You can adjust opacity here
                        child: Container(
                          color: Colors.white,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        
        // Pagination controls (Previous / Next page buttons)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: userProvider.isLoading || userProvider.currentPage <= 1
                  ? null
                  : () {
                      userProvider.changePage(
                          context, userProvider.currentPage - 1);
                    },
              child: const Text('Previous'),
            ),
            Text(
                'Page ${userProvider.currentPage} of ${userProvider.totalPages}'),
            TextButton(
              onPressed: userProvider.isLoading || userProvider.currentPage >= userProvider.totalPages
                  ? null
                  : () {
                      userProvider.changePage(
                          context, userProvider.currentPage + 1);
                    },
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
