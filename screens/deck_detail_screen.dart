import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'add_edit_card_screen.dart';
import '../widgets/card_item.dart';

class DeckDetailScreen extends StatefulWidget {
  final int deckId;

  const DeckDetailScreen({super.key, required this.deckId});

  @override
  _DeckDetailScreenState createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends State<DeckDetailScreen> {
  List<Map<String, dynamic>> cards = [];

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  Future<void> loadCards() async {
    cards = await DatabaseHelper.instance.getCards(widget.deckId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deck Cards")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditCardScreen(deckId: widget.deckId),
            ),
          ).then((_) => loadCards());
        },
      ),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (_, i) {
          final card = cards[i];
          return CardItem(
            card: card,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditCardScreen(deckId: widget.deckId, card: card),
                ),
              ).then((_) => loadCards());
            },
            onDelete: () async {
              await DatabaseHelper.instance.deleteCard(card['id']);
              loadCards();
            },
          );
          /*return ListTile(
            leading: card['imagePath'] != null
                ? Image.asset(card['imagePath'], width: 50)
                : Icon(Icons.image),
            title: Text(card['name']),
            subtitle: Text("${card['rarity']} · Qty ${card['quantity']}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance.deleteCard(card['id']);
                loadCards();
              },
            ),
          );*/
        },
      ),
    );
  }
}