import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'displayProfile.dart';

class AddInfo extends StatelessWidget {
  AddInfo({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final secondAddressController = TextEditingController();
  final postcodeController = TextEditingController();
  final townController = TextEditingController();
  final stateController = TextEditingController();

  void showPhoneNumberConfirmationDialog(BuildContext context) {
    final contactNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Phone Number'),
          content: TextField(
            controller: contactNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final confirmedPhoneNumber = contactNumberController.text;
                checkPhoneNumberMatch(confirmedPhoneNumber, context); // Check if it matches in Firestore
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      // Navigating to DisplayProfile after Firestore operations complete
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DisplayProfile(contactNumber: contactNumberController.text)),
      );
    });
  }

  void checkPhoneNumberMatch(String phoneNumber, BuildContext context) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('phoneNumbers')
        .doc(phoneNumber)
        .get();

    if (snapshot.exists) {
      print('Data match');
      final docId = snapshot.id;
      final name = nameController.text;
      updatePhoneNumberName(docId, name);

      final combinedAddress = getCombinedAddress();
      updatePhoneNumberAddress(docId, combinedAddress);

      
    } else {
      print('No data found');
    }
  }

  void updatePhoneNumberName(String docId, String name) {
    final phoneNumberRef =
        FirebaseFirestore.instance.collection('phoneNumbers').doc(docId);

    phoneNumberRef.update({'Name': name}).then((_) {
      print('Name updated successfully');
    }).catchError((error) {
      print('Failed to update name: $error');
    });
  }

  String getCombinedAddress() {
    final address = addressController.text;
    final secondAddress = secondAddressController.text;
    final postcode = postcodeController.text;
    final town = townController.text;
    final state = stateController.text;

    final combinedAddress = '$address, $secondAddress, $postcode, $town, $state';

    return combinedAddress;
  }

  void updatePhoneNumberAddress(String docId, String combinedAddress) {
    final phoneNumberRef =
        FirebaseFirestore.instance.collection('phoneNumbers').doc(docId);

    phoneNumberRef.update({'address': combinedAddress}).then((_) {
      print('Address updated successfully');
    }).catchError((error) {
      print('Failed to update address: $error');
    });
  }

  void printCombinedAddress() {
    final name = nameController.text;
    final address = addressController.text;
    final secondAddress = secondAddressController.text;
    final postcode = postcodeController.text;
    final town = townController.text;
    final state = stateController.text;

    final combinedAddress =
        '$name, $address, $secondAddress, $postcode, $town, $state';
    print(combinedAddress);
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Enter Info',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: addressController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Address',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: secondAddressController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Second Address',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: postcodeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Postcode',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: townController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Town e.g. Shah Alam',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: stateController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'State e.g. Perak',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      showPhoneNumberConfirmationDialog(context);
                      printCombinedAddress();
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
