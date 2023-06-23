import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'pin.dart';

class EnterPhoneNum extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  EnterPhoneNum({Key? key, required this.verificationId, required this.phoneNumber}) : super(key: key);

  @override
  _EnterPhoneNumState createState() => _EnterPhoneNumState();
}

class _EnterPhoneNumState extends State<EnterPhoneNum> {
  final TextEditingController _phoneNumberController = TextEditingController();

  String generateOTP() {
    // Your OTP generation logic here
    Random random = Random();
    int otpLength = 6;

    // Generate a random 6-digit OTP
    String otp = '';
    for (int i = 0; i < otpLength; i++) {
      otp += random.nextInt(10).toString();
    }

    return otp;
  }

  // Commented out the sendOTP function
  Future<void> sendOTP(String phoneNumber, String otp) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print('Failed to send OTP: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Save the verification ID and resend token for later use
        // Here, we can send the OTP manually using any SMS service provider
        // For demonstration purposes, we'll print the verification ID and OTP to the console
        print('Verification ID: $verificationId');
        print('OTP: $otp');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: Duration(seconds: 60),
    );
  }
  // 

  void checkPhoneNumber() async {
    final phoneNumber = _phoneNumberController.text;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('phoneNumbers')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.size == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number is not registered'),
        ),
      );
    } else {
      final otp = generateOTP();
      final freeUseOTP = otp;

      final documentSnapshot = querySnapshot.docs[0];
      final documentId = documentSnapshot.id;

      await FirebaseFirestore.instance
          .collection('phoneNumbers')
          .doc(documentId)
          .update({'otp': otp});

      // Commented out sending OTP to the phone number
      await sendOTP(phoneNumber, freeUseOTP);

      // Print OTP values in the console log
      printOTPValues(otp, freeUseOTP);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PinPage(
            verificationId: widget.verificationId,
            phoneNumber: widget.phoneNumber,
            otp: freeUseOTP,
          ),
        ),
      );
    }
  }

  void printOTPValues(String otp, String freeUseOTP) {
    print('OTP: $otp');
    print('Free Use OTP: $freeUseOTP');
  }

  @override
  Widget build(BuildContext context) {
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
                'Enter Your',
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
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your phone number. (+60XXX)',
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
                onPressed: checkPhoneNumber,
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
