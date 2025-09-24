import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String displayName;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.displayName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [ // Subtle shadow for depth
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20), // Adjusted margin
        padding: const EdgeInsets.all(18), // Adjusted padding
        child: Row(
          children: [
            // Default Profile Picture
            CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimary),
            ),

            const SizedBox(width: 20),

            // User Name
            Text(
              displayName,
              style: TextStyle(
                fontWeight: FontWeight.w500, // Slightly bolder text
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}