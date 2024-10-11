import 'package:flutter/material.dart';
import 'package:myapp/widgets/profile_button.dart';
import 'package:myapp/widgets/users_data_table.dart';

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
          ProfileButton()
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: DataTableExample(),
        ),
      ),
    );
  }
}
