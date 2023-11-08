import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siber_scrama/Screens/login/login.dart';

import '../map_screen/map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void storeContactsInFirestore() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contacts stored in Database'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home Page"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: const Color(0xFFFF8822),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapScreen(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                backgroundColor: const Color(0xFFFF8822), // Background color
              ),
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF8822),
                      Color(0xFFFFB129),
                    ],
                  ),
                ),
                child: const Text(
                  "LOCATION",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var status = await Permission.contacts.request();
                if (status.isGranted) {
                  storeContactsInFirestore();
                } else {
                  const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                backgroundColor: const Color(0xFFFF8822), // Background color
              ),
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF8822),
                      Color(0xFFFFB129),
                    ],
                  ),
                ),
                child: const Text(
                  "CONTACTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                } catch (e) {
                  print('Error during sign out: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                backgroundColor: const Color(0xFFFF8822), // Background color
              ),
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF8822),
                      Color(0xFFFFB129),
                    ],
                  ),
                ),
                child: const Text(
                  "LOGOUT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
