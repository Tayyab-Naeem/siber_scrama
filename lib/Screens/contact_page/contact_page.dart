import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
        elevation: 0.0,
        backgroundColor: const Color(0xFFFF8822),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_contacts[index].displayName ?? ''),
            subtitle: Text(_getFirstPhoneNumber(_contacts[index]) ?? ''),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  void fetchContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();
      _storeContactsInFirestore(_contacts);
    });
  }

  String? _getFirstPhoneNumber(Contact contact) {
    if (contact.phones!.isEmpty) {
      return 'No phone number';
    }
    return contact.phones!.first.value;
  }

  void _storeContactsInFirestore(List<Contact> contacts) async {
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Create or update a document for the user with their contact list
    await users.doc(userUid).set({
      'contacts': contacts.map((contact) {
        return {
          'displayName': contact.displayName,
          'phoneNumbers': contact.phones!.map((phone) {
            return phone.value;
          }).toList(),
        };
      }).toList(),
    }, SetOptions(merge: true));
  }
}
