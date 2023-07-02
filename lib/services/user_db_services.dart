import 'package:friday/constants.dart';
import 'package:friday/models/users.dart';
import 'package:friday/services/user_info_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UserDBServices {
  // Adds a `User` to [usersCollection] Collection
  static Future<void> addUser(Users _user) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    User? _currUser = FirebaseAuth.instance.currentUser;

    assert(_currUser is User);
    // Adds a user using `uid` of Firebase_auth as primary key
    await firestoreDB
        .collection(usersCollection)
        .doc(_currUser?.uid)
        .set(_user.toJson(), SetOptions(merge: true));
  }

  static Future<void> updateProfilePictureUrl(
      String uid, String profilePictureUrl) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

    await firestoreDB.collection(usersCollection).doc(uid).update(
      {
        'profilePictureUrl': profilePictureUrl,
      },
    );
  }

  static Future<void> updateName(String uid, String name) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

    await firestoreDB.collection(usersCollection).doc(uid).update(
      {
        'name': name,
      },
    );
  }

  static Future<void> updateAge(String uid, int age) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

    await firestoreDB.collection(usersCollection).doc(uid).update(
      {
        'age': age,
      },
    );
  }

  // Fetches User Data from Collection
  static Future<bool> fetchUserData(BuildContext context) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    User? _currUser = FirebaseAuth.instance.currentUser;
    assert(_currUser is User);

    DocumentSnapshot? userSnap;
    try {
      userSnap = await firestoreDB
          .collection(usersCollection)
          .doc(_currUser?.uid)
          .get();
    } catch (e) {
      print("Error while fetching data: ${e.toString()}");
    }
    if (userSnap == null || !userSnap.exists) {
      // Create User
      return false;
    } else {
      Users user = Users.fromJson(userSnap);
      Provider.of<UserInfoServices>(context, listen: false).setUser(user);
      return true;
    }
  }

  /// Updates User Details
  static Future<void> updateUserData(Users _user) async {
    await addUser(_user);
  }

  // Delete User from Database
  static Future<void> deleteUser(Users _user) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    User? _currUser = FirebaseAuth.instance.currentUser;
    assert(_currUser is User);

    await firestoreDB.collection(usersCollection).doc(_currUser?.uid).delete();
  }

  static updateBio(Users currentUser) {}
}
