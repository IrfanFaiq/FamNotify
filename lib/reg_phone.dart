import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'enter_phone.dart';

class RegPhoneNum extends StatelessWidget {
  const RegPhoneNum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _phoneNumberController = TextEditingController();

    // Show SnackBar when phone number is saved successfully
    void showPhoneNumberSavedSnackBar(BuildContext context) {
      final snackBar = SnackBar(
        content: Text('Phone number saved successfully.'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // Show SnackBar when phone number is already registered
    void showPhoneNumberAlreadyRegisteredSnackBar(BuildContext context) {
      final snackBar = SnackBar(
        content: Text('Phone number is already registered.'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // Check if the phone number already exists in Firestore
    Future<bool> checkIfPhoneNumberExists(String phoneNumber) async {
      final snapshot = await FirebaseFirestore.instance
          .collection('phoneNumbers')
          .doc(phoneNumber)
          .get();
      return snapshot.exists;
    }

    // Save the phone number in Firestore
    void savePhoneNumber(String phoneNumber, BuildContext context) {
      FirebaseFirestore.instance
          .collection('phoneNumbers')
          .doc(phoneNumber)
          .set({'phoneNumber': phoneNumber})
          .then((value) {
        print('Phone number saved: $phoneNumber');

        // Show SnackBar when phone number is saved successfully
        showPhoneNumberSavedSnackBar(context);
      }).catchError((error) {
        print('Failed to save phone number: $error');
      });
    }

    // Navigate to EnterPhoneNum page
    void navigateToEnterPhoneNumPage(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnterPhoneNum(
            phoneNumber: _phoneNumberController.text,
            verificationId: '',
          ),
        ),
      );
    }

    // Validate the phone number
    bool validatePhoneNumber(String phoneNumber) {
      if (phoneNumber.startsWith('+')) {
        return true;
      } else {
        final snackBar = SnackBar(
          content: Text('Please include the country code. (e.g. +60)'),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.blue[700],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 0,
              ),
              Text(
                'Register Your',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter your phone number. (+60XXXX)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  String phoneNumber = _phoneNumberController.text;

                  if (validatePhoneNumber(phoneNumber)) {
                    bool phoneNumberExists =
                        await checkIfPhoneNumberExists(phoneNumber);

                    if (phoneNumberExists) {
                      showPhoneNumberAlreadyRegisteredSnackBar(context);
                    } else {
                      savePhoneNumber(phoneNumber, context);

                      // Navigate to EnterPhoneNum page
                      navigateToEnterPhoneNumPage(context);
                    }
                  }
                },
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
