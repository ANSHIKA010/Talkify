import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact.dart';
import '../models/conversation.dart';
import '../models/message.dart';
class DBService {
  static DBService instance = DBService();
  late FirebaseFirestore _db;
  DBService() {
    _db = FirebaseFirestore.instance;
  }
  final String _userCollection = "Users";
  final String _conversationsCollection = "Conversations";

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

  Future<void> updateUserLastSeenTime(String _userID){
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.update({"lastSeen": Timestamp.now()});
  }

  Future<void> sendMessage(String _conversationID, Message _message){
    var _ref = _db.collection(_conversationsCollection).doc(_conversationID);
    var _messageType = "";
    switch (_message.type){
      case MessageType.Text:
        _messageType = "text";
        break;
      case MessageType.Image :
        _messageType = "image";
        break;
      default :
    }
    return _ref.update({
      "messages" : FieldValue.arrayUnion(
          [
            {
              "message" : _message.content,
              "senderID": _message.senderID,
              "timestamp": _message.timestamp,
              "type": _messageType,
            },

      ],
      ),
    });

  }

  Stream<Contact> getUserData(String _userID){
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.get().asStream().map((_snapshot){
      return Contact.fromFirestore(_snapshot);
    });
  }

  Stream<List<ConversationSnippet>> getUserConversations(String _userID){
    var _ref = _db.collection(_userCollection).doc(_userID).collection(_conversationsCollection);
    return _ref.snapshots().map((_snapshot){
      return _snapshot.docs.map((_doc){
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<Contact>> getUserInDB(String _searchName){
   var _ref = _db.collection(_userCollection)
   .where("name" , isGreaterThanOrEqualTo: _searchName)
   .where("name", isLessThan: _searchName + 'z');
   return _ref.get().asStream().map((_snapshot){
     return _snapshot.docs.map((_doc){
       return Contact.fromFirestore(_doc);
     }).toList();
   });
  }
  Stream<Conversation> getConversation(String _conversationID){
    var _ref  = _db.collection(_conversationsCollection).doc(_conversationID);
    return _ref.snapshots().map((_snapshot){
      return Conversation.fromFirestore(_snapshot);
    });
  }


}
