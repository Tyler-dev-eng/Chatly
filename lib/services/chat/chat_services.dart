import 'package:chatly/models/message.dart';
import 'package:chatly/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  // get instance of firestore and auth service
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore
        .collection("users")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // send message
  Future<void> sendMessage(String receiverId, String message) async {
    try {
      // get current user info
      final String currentUser = _authService.currentUser!.uid;
      final String currentUserEmail = _authService.currentUser!.email!;
      final Timestamp timestamp = Timestamp.now();

      // create a new mesaage
      Message newMessage = Message(
        id: currentUser,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
      );

      // construct chat room id for the two users (sorted to ensure uniqueness)
      List<String> ids = [currentUser, receiverId];
      ids.sort();
      String chatRoomId = ids.join('_');

      // add message to firestore
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct chat room id for the two users (sorted to ensure uniqueness)
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
