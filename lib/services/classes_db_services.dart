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
}

ClassesDBServices classesDBServices = ClassesDBServices();
