import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/database_helper.dart';

class AddEditCardScreen extends StatefulWidget {
  final int deckId;
  final Map<String, dynamic>? card;

  const AddEditCardScreen({super.key, required this.deckId, this.card});

  @override
  _AddEditCardScreenState createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String description = "";
  String rarity = "Common";
  int quantity = 1;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      name = widget.card!['name'];
      description = widget.card!['description'];
      rarity = widget.card!['rarity'];
      quantity = widget.card!['quantity'];
      imagePath = widget.card!['imagePath'];
    }
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => imagePath = image.path);
    }
  }

  Future saveCard() async {
    final data = {
      'deckId': widget.deckId,
      'name': name,
      'description': description,
      'rarity': rarity,
      'quantity': quantity,
      'imagePath': imagePath,
    };

    if (widget.card == null) {
      await DatabaseHelper.instance.insertCard(data);
    } else {
      await DatabaseHelper.instance.updateCard(data, widget.card!['id']);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Card")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: "Card Name"),
                onChanged: (v) => name = v,
              ),
              TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                initialValue: description,
                decoration: InputDecoration(labelText: "Description"),
                onChanged: (v) => description = v,
              ),
              DropdownButtonFormField(
                initialValue: rarity,
                items: ["Uncommon","Common", "Rare", "Epic", "Legendary"]
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => rarity = v!,
              ),
              TextFormField(
                initialValue: quantity.toString(),
                decoration: InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                onChanged: (v) => quantity = int.tryParse(v) ?? 1,
              ),
              SizedBox(height: 20),
              imagePath != null
                  ? Image.file(File(imagePath!), height: 150)
                  : Container(height: 150, color: Colors.grey[300]),
              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text("Pick Image"),
                onPressed: pickImage,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveCard,
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}