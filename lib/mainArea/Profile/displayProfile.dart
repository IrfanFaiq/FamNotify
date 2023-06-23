import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addInfo.dart'; // Replace "your_project_name" with your actual project name

class DisplayProfile extends StatelessWidget {
  final String contactNumber;

  const DisplayProfile({Key? key, required this.contactNumber}) : super(key: key);

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchProfileData() async {
    if (contactNumber.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('phoneNumbers')
          .doc(contactNumber)
          .get();
    } else {
      throw Exception('Contact number is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Center(
        child: Container(
          width: 300,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: Future.delayed(Duration(seconds: 2), () => fetchProfileData()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!.data();
                  final name = data?['Name'];
                  final address = data?['address'];

                  return Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'User Information',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Name: $name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Address: $address',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddInfo()),
                            );
                          },
                          child: Text('Update'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('No data found');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
