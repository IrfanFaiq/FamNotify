import 'package:fam_notify/mainArea/sensor.dart';
import 'package:flutter/material.dart';
import 'Contacts/contList.dart';
import 'Contacts/displayContact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Profile/userProfile.dart';
import 'location.dart';
import 'notifyPage.dart';

class HomePage extends StatelessWidget {
  final String? userId;

  const HomePage({Key? key, this.userId, required String verificationId, required String phoneNumber, required String otp})
      : super(key: key);

  Future<bool> checkFamilyContactsExist() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('FamilyContacts')
        .where('userId', isEqualTo: userId)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty;
  }

  void navigateToContacts(BuildContext context) async {
    bool familyContactsExist = await checkFamilyContactsExist();
    if (familyContactsExist) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DisplayNumbers(userId: userId)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListContact(userId: userId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Set the background color to blue
      appBar: AppBar(
        title: Text('Home'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(height: 30), // Add empty space of 20 pixels
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileEmpty(phoneNumber: '',)),
                );
              },
            ),
            ListTile(
              title: Text('Contacts'),
              onTap: () {
                navigateToContacts(context);
              },
            ),            
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SensorPage()),
                );
              },
              child: Text(
                'Sensor',
                style: TextStyle(color: Colors.blue), // Set the text color to blue
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Set the button color to white
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationPage()),
                );
              },
              child: Text(
                'Location',
                style: TextStyle(color: Colors.blue), // Set the text color to blue
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Set the button color to white
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotifyPage()),
                );
              },
              child: Text(
                'Notify',
                style: TextStyle(color: Colors.blue), // Set the text color to blue
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Set the button color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
