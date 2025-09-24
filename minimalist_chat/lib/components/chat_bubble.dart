import 'package:flutter/material.dart';
import 'package:minimalist_chat/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget{
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container (
      decoration: BoxDecoration(
        color: isCurrentUser
            ? colorScheme.primary // Current user's bubbles use primary color
            : colorScheme.secondary, // Other user's bubbles use secondary color
        borderRadius: BorderRadius.circular(16), // More rounded corners
        boxShadow: [ // Subtle shadow for depth
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15), // Adjusted margin
      child: Text(
        message,
        style: TextStyle(
          color: isCurrentUser
              ? colorScheme.onPrimary // Text color for current user's bubble
              : colorScheme.onSurface, // Text color for other user's bubble
        ),
      ),
    );
  }
}
