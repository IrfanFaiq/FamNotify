import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'displayContact.dart';

class AddContact extends StatelessWidget {
  const AddContact({Key? key}) : super(key: key);

  void saveContactNumber(BuildContext context, String contactNumber) async {
    try {
      FirebaseFirestore.instance
          .collection('FamilyContacts')
          .doc(contactNumber) // Use contactNumber as the document ID
          .set({'contactNumber': contactNumber})
          .then((value) {
        print('Contact number saved: $contactNumber');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contact saved successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
      }).catchError((error) {
        print('Failed to save contact number: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save contact number.'),
            duration: Duration(seconds: 3),
          ),
        );
      });
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactNumberController = TextEditingController();

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Contact Number',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 50.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: contactNumberController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone number.ex(+60XXXXXX)',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                ElevatedButton(
                  onPressed: () {
                    String contactNumber = contactNumberController.text;
                    saveContactNumber(context, contactNumber); // Pass the context parameter
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DisplayNumbers()),
                    );
                  },
                  child: Text(
                    'Display Numbers',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
