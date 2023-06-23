import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'enter_phone.dart';
import 'mainArea/home.dart';

class PinPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String otp;

  PinPage({required this.verificationId, required this.phoneNumber, required this.otp});

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController _pinController = TextEditingController();
  String? errorMessage;

  void checkOTP() async {
    final otp = _pinController.text;

    if (otp == widget.otp) {
      // OTP matches
      // Proceed to the HomePage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            verificationId: widget.verificationId,
            phoneNumber: widget.phoneNumber,
            otp: widget.otp,
          ),
        ),
      );
    } else {
      // OTP does not match
      setState(() {
        errorMessage = 'Invalid OTP. Please try again.';
      });
    }
  }

  void navigateToEnterPhoneNum() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterPhoneNum(phoneNumber: '', verificationId: '',),
      ),
    );
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Container(
                margin: EdgeInsets.all(16.0),
                child: Text(
                  'Enter PIN',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF512DA8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF512DA8)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF512DA8)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your PIN',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              if (errorMessage != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              SizedBox(height: 16.0),
              Text(
                'Didn\'t receive OTP? Click',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: navigateToEnterPhoneNum,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                    fixedSize: Size(140, 60),
                  ),
                  child: Text('Here', style: TextStyle(fontSize: 20, color: Colors.blue[700])),
                ),
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: checkOTP,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[700],
                    fixedSize: Size(140, 60),
                  ),
                  child: Text('Confirm', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
