import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/classes.dart';

class ClassesDBServices {
  Future<List<Classes>> getClassList(String collegeID) async {
    List<Classes> classesList = [];
    return FirebaseFirestore.instance
        .collection('colleges')
        .doc(collegeID)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        final classesMap = documentSnapshot.data()['classes'] as Map;

        classesMap.forEach((key, value) {
          classesList.add(Classes.fromMap(value));
        });
      }
      return classesList;
    });
  }

  Map<String, Classes> generateDummyClasses() {
    final uuid = Uuid();

    Map<String, Classes> data = {};

    classes.forEach((element) {
      data[uuid.v4()] = element;
    });

    return data;
  }

  Future<void> addDummyClassesToFirestore() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference =
        _firestore.collection('colleges').doc('USICT-BTECH-CSE-3');
    final Map<String, Classes> classesData = generateDummyClasses();

    documentReference.update({
      'classes': classesData.map((key, value) {
        return MapEntry(key, value.toMap());
      })
    });
  }

  Future<void> verifyCollegeFieldAndUpdate(
      String _collegeName, String _course, String _dept) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.doc('colleges/$_collegeName').get();

    print(documentSnapshot.data()['courses']);

    if (documentSnapshot.data()['courses'] == null) {
      print("No Course Registered");
      FirebaseFirestore.instance.doc('colleges/$_collegeName').set({
        'courses': {
          _course: [_dept],
        },
      });
    } else {
      print("At least one course present");
      if (documentSnapshot.data()['courses'].keys.contains(_course)) {
        print("Same Course Present");
        print(documentSnapshot.data()['courses'][_course]);

        if (documentSnapshot.data()['courses'][_course].contains(_dept)) {
          print("Same Dept Present");
        } else {
          print("Dept not present");
          print(_dept);

          Map<String, dynamic> _currCourses =
              documentSnapshot.data()['courses'];
          _currCourses[_course].add(_dept);

          FirebaseFirestore.instance.doc('colleges/$_collegeName').update({
            'courses': _currCourses,
          });
        }
      } else {
        print("That new Course not present");
        Map<String, dynamic> take = documentSnapshot.data()['courses'];
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

ClassesDBServices classesDBServices = ClassesDBServices();
