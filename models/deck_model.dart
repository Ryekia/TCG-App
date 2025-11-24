class DeckModel {
  final int? id;
  final String name;

  DeckModel({this.id, required this.name});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}