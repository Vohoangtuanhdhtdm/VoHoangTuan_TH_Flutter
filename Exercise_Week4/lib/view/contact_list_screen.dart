import 'package:flutter/material.dart';

class ContactListScreen extends StatelessWidget {
  final List<String> contacts = List.generate(
    20,
    (index) => 'Contact ${index + 1}',
  );

  ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List View Exercise")),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(contacts[index]),
            subtitle: Text("Phone number placeholder"),
          );
        },
      ),
    );
  }
}
