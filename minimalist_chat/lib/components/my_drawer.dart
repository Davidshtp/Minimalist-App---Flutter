import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    // get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.getCurrentUser();
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.background,
      shape: const RoundedRectangleBorder( // Add rounded corners to the drawer itself
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // User Info Header
              DrawerHeader(
                decoration: BoxDecoration(
                  color: colorScheme.primary, // Use primary color for header background
                ),
                child: currentUser == null
                    ? Center(
                        child: Icon(
                          Icons.message,
                          color: colorScheme.onPrimary, // Icon color on primary background
                          size: 40,
                        ),
                      )
                    : StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(currentUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: colorScheme.onPrimary, // Loading indicator color
                              ),
                            );
                          }

                          final userData = snapshot.data!.data() as Map<String, dynamic>;
                          final displayName = userData['displayName'] as String?;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Default Profile Picture
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: colorScheme.onPrimary, // Avatar background
                                child: Icon(Icons.person, size: 40, color: colorScheme.primary), // Icon color
                              ),
                              const SizedBox(height: 10),
                              Text(
                                displayName ?? 'User',
                                style: TextStyle(
                                  color: colorScheme.onPrimary, // Text color on primary background
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),

              // home list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("H O M E", style: TextStyle(color: colorScheme.onSurface)),
                  leading: Icon(Icons.home, color: colorScheme.inversePrimary), // Use inversePrimary for icon
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              // settings list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text('S E T T I N G S', style: TextStyle(color: colorScheme.onSurface)),
                  leading: Icon(Icons.settings, color: colorScheme.inversePrimary), // Use inversePrimary for icon
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);
                    // navigate to settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // logout list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: Text('L O G O U T', style: TextStyle(color: colorScheme.onSurface)),
              leading: Icon(Icons.logout, color: colorScheme.inversePrimary), // Use inversePrimary for icon
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}