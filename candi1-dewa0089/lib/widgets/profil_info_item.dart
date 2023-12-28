import 'package:flutter/material.dart';

class ProfilInfoItem extends StatelessWidget {
  const ProfilInfoItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.showEdition = false,
    this.onEditPressed,
    required this.iconColor,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final String value;
  final bool showEdition;
  final VoidCallback? onEditPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            if (showEdition)
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: onEditPressed,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}
