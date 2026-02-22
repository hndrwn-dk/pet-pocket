import 'package:flutter/material.dart';

class PetAvatar extends StatelessWidget {
  final String skinKey;
  final double size;
  
  const PetAvatar({
    super.key,
    required this.skinKey,
    this.size = 120,
  });
  
  @override
  Widget build(BuildContext context) {
    Color avatarColor;
    IconData avatarIcon;
    
    switch (skinKey) {
      case 'ninja':
        avatarColor = Colors.grey[800]!;
        avatarIcon = Icons.pets;
        break;
      case 'gold':
        avatarColor = Colors.amber;
        avatarIcon = Icons.star;
        break;
      default:
        avatarColor = Colors.blue;
        avatarIcon = Icons.pets;
    }
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatarColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        avatarIcon,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
}

