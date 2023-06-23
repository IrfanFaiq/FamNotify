import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateContact extends StatefulWidget {
  @override
  _UpdateContactState createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  List<String> deletedContacts = [];

  Future<void> deleteContact(String contactId) async {
    try {
      await FirebaseFirestore.instance
          .collection('FamilyContacts')
          .doc(contactId)
          .delete();
      print('Contact deleted: $contactId');
      // Add the contact ID to the list of deleted contacts
      deletedContacts.add(contactId);
      // TODO: Show a success message or perform any other action
    } catch (error) {
      print('Failed to delete contact: $error');
      // TODO: Show an error message or perform any other action
    }
  }

  Future<void> undoDeleteContact(String contactId) async {
    try {
      await FirebaseFirestore.instance
          .collection('FamilyContacts')
          .doc(contactId)
          .set({'contactNumber': contactId});
      print('Contact undeleted: $contactId');
      // Remove the contact ID from the list of deleted contacts
      deletedContacts.remove(contactId);
      // TODO: Show a success message or perform any other action
    } catch (error) {
      print('Failed to undelete contact: $error');
      // TODO: Show an error message or perform any other action
    }
  }

  void navigateToDisplayNumbers() {
    // TODO: Implement the navigation to the DisplayNumbers page
    Navigator.pop(context);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => DisplayNumbers()),
    // );
  }

  void cancelDelete() {
    // Undo deletion of contacts
    for (final contactId in deletedContacts) {
      undoDeleteContact(contactId);
    }
    // Clear the list of deleted contacts
    deletedContacts.clear();
    // TODO: Show a message or perform any other action
  }

  void saveChanges() {
    // Show a Snackbar to display "Saved changes"
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved changes')),
    );
    // TODO: Perform any other action
    navigateToDisplayNumbers();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Contact Numbers',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 50.0),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('FamilyContacts').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          final contactId = document.id;
                          final isDeleted = deletedContacts.contains(contactId);
                          return ListTile(
                            title: Text(document['contactNumber']),
                            trailing: isDeleted
                                ? IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red, // Set delete icon color to red
                                    ),
                                    onPressed: () {
                                      undoDeleteContact(contactId);
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red, // Set delete icon color to red
                                    ),
                                    onPressed: () {
                                      deleteContact(contactId);
                                    },
                                  ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: cancelDelete,
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: saveChanges,
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
