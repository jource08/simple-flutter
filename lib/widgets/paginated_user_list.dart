import 'package:flutter/material.dart';
import 'package:myapp/providers/user_list_provider.dart';
import 'package:myapp/screens/user_detail_screen.dart';
import 'package:provider/provider.dart';

class PaginatedUserList extends StatelessWidget {
  const PaginatedUserList({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    // Trigger a refresh by re-fetching the data
    await Provider.of<UserListProvider>(context, listen: false)
        .fetchUsers(context, 1);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserListProvider>(context);

    return GestureDetector(
      onTap: () {
        // Unfocus the search input when tapping anywhere outside
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (searchTerm) {
                  // Update the search term and fetch users based on the search
                  userProvider.setSearchTerm(context, searchTerm);
                },
                decoration: const InputDecoration(
                  labelText: 'Search Users',
                  hintText: 'username | fullname | email',
                  hintStyle: TextStyle(color: Colors.black38),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: Stack(
                  children: [
                    if (userProvider.searchTerm.isEmpty &&
                        userProvider.users.isEmpty)
                      const Center(
                        child: Text(
                          "No search term entered, please type to search for users.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    else if (userProvider.users.isEmpty)
                      const Center(
                        child: Text(
                          "No users found for the current search.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    else
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
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) {
                                          return child;
                                        } else {
                                          return const Icon(Icons.person,
                                              size: 40);
                                        }
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error,
                                            size: 40);
                                      },
                                    )
                                  : const Icon(Icons.person, size: 40),
                            ),
                            title: Text("${user.username} (${user.fullname})"),
                            subtitle: Text(user.email ?? ""),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed:
                      userProvider.isLoading || userProvider.currentPage <= 1
                          ? null
                          : () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              userProvider.changePage(
                                  context, userProvider.currentPage - 1);
                            },
                  child: const Text('Previous'),
                ),
                Text(
                    'Page ${userProvider.currentPage} of ${userProvider.totalPages}\n All data: ${userProvider.totalCount}',textAlign: TextAlign.center,),
                TextButton(
                  onPressed: userProvider.isLoading ||
                          userProvider.currentPage >= userProvider.totalPages
                      ? null
                      : () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          userProvider.changePage(
                              context, userProvider.currentPage + 1);
                        },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
