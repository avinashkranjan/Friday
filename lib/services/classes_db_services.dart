import 'package:friday/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClassesDBServices {
  Stream<DocumentSnapshot> getClassListAsStream(String collegeID) {
    final Stream<DocumentSnapshot> streamDocumentSnapshot = FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots();

    return streamDocumentSnapshot;
  }

  Future<void> addNewClassToFireStore(String _todayDate, Mode _mode,
      String _subject, String _teacher, String _time,
      [String? _joinLink]) async {
    final DocumentSnapshot documentSnapShot = await FirebaseFirestore.instance
        .doc('users/${FirebaseAuth.instance.currentUser?.uid}')
        .get();

    Map<String, dynamic> _classesListStored = Map<String, dynamic>();
    _classesListStored = (documentSnapShot.data() as Map)['classes'];

    if (_classesListStored.isNotEmpty &&
        _classesListStored.containsKey(_todayDate)) {
      final List<dynamic> dateSpecificRoutine =
          _classesListStored[_todayDate].toList();

      print("New Data Added in Old Date Container");

      dateSpecificRoutine.add({
        'subject': _subject,
        'type': modeEnumToString(_mode),
        'teacherName': _teacher,
        'joinLink': modeEnumToString(_mode) == "Online" ? _joinLink : null,
        'time': '$_todayDate $_time',
      });

      _classesListStored[_todayDate] = dateSpecificRoutine;
    } else {
      print("New Date Container Added");

      _classesListStored.addAll({
        _todayDate: [
          {
            'subject': _subject,
            'type': modeEnumToString(_mode),
            'teacherName': _teacher,
            'joinLink': modeEnumToString(_mode) == "Online" ? _joinLink : null,
            'time': '$_todayDate $_time',
          }
        ]
      });
    }

    FirebaseFirestore.instance
        .doc('users/${FirebaseAuth.instance.currentUser?.uid}')
        .update({
      'classes': _classesListStored,
    });
  }

  Future<void> verifyCollegeFieldAndUpdate(
      String _collegeName, String _course, String _dept) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.doc('colleges/$_collegeName').get();

    print((documentSnapshot.data() as Map)['courses']);

    if ((documentSnapshot.data() as Map)['courses'] == null) {
      print("No Course Registered");
      FirebaseFirestore.instance.doc('colleges/$_collegeName').set({
        'courses': {
          _course: [_dept],
        },
      });
    } else {
      print("At least one course present");
      if ((documentSnapshot.data() as Map)['courses'].keys.contains(_course)) {
        print("Same Course Present");
        print((documentSnapshot.data() as Map)['courses'][_course]);

        if ((documentSnapshot.data() as Map)['courses'][_course]
            .contains(_dept)) {
          print("Same Dept Present");
        } else {
          print("Dept not present");
          print(_dept);

          Map<String, dynamic> _currCourses =
              (documentSnapshot.data() as Map)['courses'];
          _currCourses[_course].add(_dept);

          FirebaseFirestore.instance.doc('colleges/$_collegeName').update({
            'courses': _currCourses,
          });
        }
      } else {
        print("That new Course not present");
        Map<String, dynamic> take = (documentSnapshot.data() as Map)['courses'];
        take.addAll({
          _course: [_dept],
        });
        FirebaseFirestore.instance.doc('colleges/$_collegeName').update({
          'courses': take,
        });
      }
    }
  }
}
