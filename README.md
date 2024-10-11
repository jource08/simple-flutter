# Simple Flutter App

A new Flutter project.

## Getting Started

1. **Update Endpoint**:  
   Update the endpoint in the file located at `lib/constants/app_const.dart` to the appropriate URL for your API.

## Features

- **Login**: User authentication with email and password.
- **Register**: 
  - Includes password validation (requires upper and lower case letters, a number, and a symbol).
- **Paginated User List**: Display users in a paginated list format for efficient data loading and browsing.
  - **User Detail**: Selected user detail page.
- **Logged In User Profile**: Display the logged-in user's profile information.
    - **Logged In User Profile**: Edit profile.
- **Pull to Refresh**: Users can refresh the list by pulling down.

## References

Here are a few references that can help guide the development of this project:

- [Paginated Data Table Widget](https://api.flutter.dev/flutter/material/PaginatedDataTable-class.html)  
  Use this class for implementing paginated data tables in Flutter apps.
  
- [Popup Menu Button](https://api.flutter.dev/flutter/material/PopupMenuButton-class.html)  
  Learn how to implement popup menu buttons for offering additional actions.
