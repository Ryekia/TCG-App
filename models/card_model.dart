class CardModel {
  final int? id;
  final int deckId;
  final String name;
  final String description;
  final String rarity;
  final int quantity;
  final String? imagePath;

  CardModel({
    this.id,
    required this.deckId,
    required this.name,
    required this.description,
    required this.rarity,
    required this.quantity,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'deckId': deckId,
    'name': name,
    'description': description,
    'rarity': rarity,
    'quantity': quantity,
    'imagePath': imagePath,
  };
}