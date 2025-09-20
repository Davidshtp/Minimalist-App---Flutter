import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minimalist_chat/models/message.dart';

class ChatService {
  // get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  /*
  List<Map<String,dynamic>> = 
  [
    {
      'email': test@gmail.com,
      'id': ..
    },



  ]
  */

  Stream<List<Map<String, dynamic>>> getUsersStream() {
  return _firestore.collection("Users").snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      // go through each individual user
      final user = doc.data();

      // return user
      return user;
    }).toList();
  });
}


  // send message
  Future <void> sendMessage(String receiverId, message) async {
    // get curren user info
    final String currenUserID= _auth.currentUser!.uid;
    final String currenUserEmail= _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create new message
    Message newMessage = Message(
      senderId: currentUserEmail,
      senderEmail: currentUserID,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // add  new message to database 
    await _firestore
      .collection("ChatRooms")
      .doc(chatRoomID)
      .collection("Messages")
      .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
      .collection("ChatRooms")
      .doc(chatRoomID)
      .collection("Messages")
      .orderBy("timestamp", descending: true)
      .snapshots();

  }
  
}
