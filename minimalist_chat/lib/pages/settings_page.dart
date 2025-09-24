import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimalist_chat/services/auth/auth_service.dart';
import 'package:minimalist_chat/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = AuthService();

  // Function to show dialog for updating display name
  Future<void> _editDisplayName(BuildContext context, String currentName) async {
    final TextEditingController nameController = TextEditingController(text: currentName);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Display Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await _authService.updateUserProfile(displayName: nameController.text);
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.getCurrentUser();
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("No user logged in.")));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').doc(currentUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong."));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found."));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final displayName = userData['displayName'] as String?;

          return Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Default Profile Picture
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.person, size: 60, color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(height: 20),

                // Display Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      displayName ?? 'No Name',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.grey.shade600),
                      onPressed: () => _editDisplayName(context, displayName ?? ''),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Email
                Text(
                  currentUser.email ?? '',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),

                const Spacer(),

                // Dark Mode Toggle
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Dark Mode"),
                      CupertinoSwitch(
                        value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                        onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}