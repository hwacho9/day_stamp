import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore firestore;

  DatabaseService({FirebaseFirestore? firestore})
      : this.firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addEntry(String userId, String date, String mood, String weather,
      List<String> tasks, String diary, List<String> emojis) async {
    var dateParts = date.split('-');
    var year = dateParts[0];
    var month = dateParts[1];
    var collectionMonth = 'entries_$year$month';

    await firestore
        .collection('entries')
        .doc(userId)
        .collection(collectionMonth)
        .add({
      'date': date,
      'mood': mood,
      'weather': weather,
      'tasks': tasks,
      'diary': diary,
      'emojis': emojis,
    });
  }
}
