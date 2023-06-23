// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotifyPage extends StatelessWidget {
//   final String? userId;
//   final String serverToken =
//       'AAAAGKgBwTs:APA91bG3ZN-2udUskGfpPlngG0q9AC8ZSsK92U9U83ajSAJdjK70lugtUYgPi24HxaMJcWFy_hkQ7XyxtTbK914T3lPY2HHJ9L4hrGnTFrkfXY56pxqy3vOBl0MIAhgpTAIbdj9I38Ir'; // Replace with your FCM server token

//   NotifyPage({Key? key, this.userId}) : super(key: key);

//   Future<List<String>> getContactNumbers() async {
//     QuerySnapshot contactNumbersSnapshot = await FirebaseFirestore.instance
//         .collection('FamilyContacts')
//         .where('userId', isEqualTo: userId)
//         .get();

//     List<String> contactNumbers = contactNumbersSnapshot.docs
//         .map((document) => document['contactNumber'] as String)
//         .toList();

//     return contactNumbers;
//   }

//   Future<void> sendNotification(List<String> tokens) async {
//     final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

//     // Subscribe all device tokens to the topic
//     await Future.forEach(tokens, (token) async {
//       await firebaseMessaging.subscribeToTopic('notifications');
//     });

//     final Map<String, dynamic> notification = {
//       'title': 'Hey There',
//       'body': 'test notify',
//     };

//     final Map<String, dynamic> data = {
//       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//       'sound': 'default',
//       'status': 'done',
//     };

//     final Map<String, dynamic> message = {
//       'notification': notification,
//       'priority': 'high',
//       'data': data,
//     };

//     // Send the message to the topic
//     if (tokens.isNotEmpty) {
//       await firebaseMessaging.sendMulticast(
//         message: message,
//         tokens: tokens,
//       );
//     }

//     // Print the list of device tokens to the console
//     print('Device Tokens: $tokens');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notify Page'),
//       ),
//       body: FutureBuilder<List<String>>(
//         future: getContactNumbers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             List<String>? contactNumbers = snapshot.data;
//             if (contactNumbers != null && contactNumbers.isNotEmpty) {
//               sendNotification(contactNumbers); // Send notifications to all contact numbers
//               return Center(child: Text('Notifications sent to all contact numbers'));
//             } else {
//               return Center(child: Text('No contact numbers found.'));
//             }
//           }
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class NotifyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'),
      ),
      body: Center(
        child: Text(
          'Notify Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
