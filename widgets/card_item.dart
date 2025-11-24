import 'dart:io';
import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final Map<String, dynamic> card;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CardItem({
    super.key,
    required this.card,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // ----- IMAGE -----
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: card['imagePath'] != null
                    ? Image.file(
                  File(card['imagePath']),
                  width: 60,
                  height: 80,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 60,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 32),
                ),
              ),

              const SizedBox(width: 16),

              // ----- CARD INFO -----
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card['name'] ?? "Unknown Card",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card['rarity'] ?? "Unknown rarity",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Qty: ${card['quantity'] ?? 0}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              // ----- DELETE BUTTON -----
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}