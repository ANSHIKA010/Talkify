import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static DBService instance = DBService();
  late FirebaseFirestore _db;
  DBService() {
    _db = FirebaseFirestore.instance;
  }
  final String _userCollection = "Users";

  Future<void> createUserInDB(
      String uid, String name, String email, String imageURL) async {
    try {
      return await _db.collection(_userCollection).doc(uid).set({
        "name": name,
        "email": email,
        "image": imageURL,
        "lastSeen": DateTime.now().toUtc(),
      });
    }
    catch (e){
      print(e);
    }

  }
}
