import 'dart:async'; // Import for debouncing

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:myapp/constants/app_const.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/session_provider.dart';
import 'package:provider/provider.dart';

class UserListProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<User> _users = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  final int _limit = 10;
  String _searchTerm = "";

  List<User> get users => _users;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get limit => _limit;
  int get totalCount => _totalCount;
  String get searchTerm => _searchTerm;

  // Cache user data
  void cacheUsers(List<User> fetchedUsers, int currentPage, int totalPages, int totalCount) {
    _users = fetchedUsers;
    _currentPage = currentPage;
    _totalPages = totalPages;
    _totalCount = totalCount;
    notifyListeners();
  }

  void setSearchTerm(BuildContext context, String search) {
    _searchTerm = search;
    notifyListeners(); // Notify when search term changes

    // Call fetchUsers directly with the provided context
    fetchUsers(context, 1); // 1 is the page number for the initial search
  }

  Future<void> fetchUsers(BuildContext context, int page) async {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      String url = '${AppConst.listUserUrl}?page=$page&limit=$_limit';

      // Only add searchTerm to the URL if it's not empty
      if (_searchTerm.isNotEmpty) {
        url += '&search=$_searchTerm';
      }

      String cookie =
          Provider.of<SessionProvider>(context, listen: false).authCookie;
      Dio dio = Dio();
      dio.options.headers = {
        "Cookie": cookie,
      };

      Response response = await dio.get(url);

      debugPrint(url);
      if (response.statusCode == 200) {
        debugPrint('Users fetched successfully: ${response.data}');

        // Parse the response and update the list of users
        List<User> fetchedUsers = (response.data['data'] as List)
            .map((userJson) => User.fromJson(userJson))
            .toList();

        // Extract total count from response
        int totalCount = response.data['totalCount'];

        // Update the cache with total count
        cacheUsers(fetchedUsers, response.data['currentPage'],
            response.data['totalPages'], totalCount);
      } else {
        debugPrint('Error fetching users: ${response.statusCode}');
        // Reset data in case of failure
        _users = [];
        _currentPage = 1;
        _totalPages = 1;
        _totalCount = 0; 
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners(); // Notify listeners after the current build phase
        });
      }
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners(); // Notify listeners after the current build phase
      });
    } catch (error) {
      _isLoading = false;
      _users = []; // Reset in case of error
      _currentPage = 1;
      _totalPages = 1;
      _totalCount = 0; 
      debugPrint('Error occurred while fetching users: $error');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners(); // Notify listeners after the current build phase
      });
      rethrow; // Re-throw error after handling
    }
  }

  void changePage(BuildContext context, int page) {
    if (page >= 1 && page <= _totalPages) {
      fetchUsers(context, page);
    }
  }
}
