import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationSnippet{
  final String id;
  final String conversationID;
  final String lastMessage;
  final String name;
  final String image;
  final int unseenCount;
  final Timestamp timestamp;

  ConversationSnippet(
  {
     required this.conversationID,
     required this.id,
     required this.lastMessage,
     required this.unseenCount,
     required this.timestamp,
     required this.name,
     required this.image,
});
  factory ConversationSnippet.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data() as Map<String,dynamic>;
    return ConversationSnippet(
      id: _snapshot.id,
      conversationID: _data["conversationID"],
      lastMessage: _data["lastMessage"] !=null ? _data["lastMessage"] : "",
      unseenCount: _data["unseenCount"],
      timestamp: _data["timestamp"],
      name: _data["name"],
      image: _data["image"],
    );
  }
}