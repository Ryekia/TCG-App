import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'deck_detail_screen.dart';

class DeckListScreen extends StatefulWidget {
  const DeckListScreen({super.key});

  @override
  _DeckListScreenState createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> {
  List<Map<String, dynamic>> decks = [];

  @override
  void initState() {
    super.initState();
    loadDecks();
  }

  Future<void> loadDecks() async {
    decks = await DatabaseHelper.instance.getDecks();
    setState(() {});
  }

  Future<void> addDeck() async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("New Deck"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            child: Text("Add"),
            onPressed: () async {
              await DatabaseHelper.instance.insertDeck({'name': controller.text});
              Navigator.pop(context);
              loadDecks();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Decks")),
      floatingActionButton: FloatingActionButton(
        onPressed: addDeck,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: decks.length,
        itemBuilder: (context, i) {
          final deck = decks[i];
          return ListTile(
            title: Text(deck['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeckDetailScreen(deckId: deck['id']),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance.deleteDeck(deck['id']);
                loadDecks();
              },
            ),
          );
        },
      ),
    );
  }
}