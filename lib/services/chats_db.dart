import 'package:cloud_firestore/cloud_firestore.dart';

// Function to create a new group
Future<String> createGroup(String groupName, String userId) async {
  CollectionReference groupsRef =
      FirebaseFirestore.instance.collection('groups');

  DocumentReference groupDocRef = await groupsRef.add({
    'name': groupName,
    'users': [userId],
    'createdAt': FieldValue.serverTimestamp(),
  });

  return groupDocRef.id;
}

// Function to send a message in a group chat
Future<void> sendMessage(
    String groupId, String senderId, String message) async {
  CollectionReference messagesRef = FirebaseFirestore.instance
      .collection('groups')
      .doc(groupId)
      .collection('messages');

  await messagesRef.add({
    'senderId': senderId,
    'message': message,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

// Function to fetch group messages
Stream<QuerySnapshot<Object?>> getGroupMessages(String groupId) {
  CollectionReference messagesRef = FirebaseFirestore.instance
      .collection('groups')
      .doc(groupId)
      .collection('messages');

  return messagesRef.orderBy('timestamp').snapshots();
}

// Function to search for users by ID and perform additional actions
Future<void> searchUsersByIdAndPerformActions(
    String userId, String groupId, String message) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('userId', isEqualTo: userId)
      .get();

  if (snapshot.docs.isNotEmpty) {
    // DocumentSnapshot userSnapshot = snapshot.docs.first;
    // String userName = userSnapshot['name'];

    // Create a new group
    createGroup(groupId, userId).then((groupId) {
      print('Group created with ID: $groupId');

      // Send a message in the group
      sendMessage(groupId, userId, message).then((_) {
        print('Message sent successfully');

        // Get group messages
        Stream<QuerySnapshot<Map<String, dynamic>>>? messagesStream =
            getGroupMessages(groupId)
                as Stream<QuerySnapshot<Map<String, dynamic>>>?;
        messagesStream?.listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> messageDocs =
              snapshot.docs;

          for (var messageDoc in messageDocs) {
            String senderId = messageDoc['senderId'];
            String message = messageDoc['message'];

            print('[$senderId]: $message');
          }
        });
      }).catchError((error) {
        print('Failed to send message: $error');
      });
    }).catchError((error) {
      print('Failed to create group: $error');
    });
  } else {
    print('User not found');
  }
}

// Usage example
void exampleUsage() {
  searchUsersByIdAndPerformActions('user123', 'group456', 'Hello everyone!');
}
