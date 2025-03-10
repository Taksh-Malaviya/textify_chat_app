import 'dart:developer';
import 'package:chat_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modal/user_model.dart';
import '../modal/message_model.dart';

class FireStoreService {
  FireStoreService._();

  static FireStoreService fireStoreService = FireStoreService._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> addUsers({required UserModel user}) async {
    await fireStore.collection("Users").doc(user.email).set(user.toMap());
  }

  Stream<List<UserModel>> fetchUsers() {
    return FirebaseFirestore.instance.collection("Users").snapshots().asyncMap(
      (snapshot) async {
        return Future.wait(snapshot.docs.map((doc) async {
          Map<String, dynamic> data = doc.data();
          return UserModel(
            name: data['name'] ?? 'Unknown',
            email: data['email'] ?? 'No Email',
            password: '',
            id: data['id'] ?? '',
            token: data['token'] ?? '',
          );
        }));
      },
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchCurrentUser() {
    String email = AuthService.authService.currentUser?.email ?? "";

    log("Email : $email");

    return fireStore.collection("Users").doc(email).snapshots();
  }

  String getChatId(String user1, String user2) {
    List<String> users = [user1, user2];
    users.sort();
    return users.join("_");
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    String chatId = getChatId(senderId, receiverId);

    DocumentReference newMessageRef =
        fireStore.collection("Chats").doc(chatId).collection("Messages").doc();

    MessageModel newMessage = MessageModel(
      id: newMessageRef.id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: Timestamp.now(),
    );

    await newMessageRef.set(newMessage.toMap());
  }

  Stream<List<MessageModel>> fetchMessages(String senderId, String receiverId) {
    String chatId = getChatId(senderId, receiverId);

    return fireStore
        .collection("Chats")
        .doc(chatId)
        .collection("Messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  String chatDocID({required String sender, required String reciever}) {
    List<String> chatUsers = [sender, reciever];
    chatUsers.sort();
    return chatUsers.join('_');
  }

  Future<void> updateMessage({
    required String messageId,
    required String updatedMessage,
    required String senderId,
    required String receiverId,
  }) async {
    String chatId = getChatId(senderId, receiverId);

    await fireStore
        .collection("Chats")
        .doc(chatId)
        .collection("Messages")
        .doc(messageId)
        .update({
      'message': updatedMessage,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteChat({
    required String sender,
    required String receiver,
    required String id,
  }) async {
    String chatId = chatDocID(sender: sender, reciever: receiver);

    await fireStore
        .collection("Chats")
        .doc(chatId)
        .collection("Messages")
        .doc(id)
        .delete();
  }

  Future<void> addReaction({
    required String messageId,
    required String senderId,
    required String receiverId,
    required String reaction,
  }) async {
    String chatId = getChatId(senderId, receiverId);

    await fireStore
        .collection("Chats")
        .doc(chatId)
        .collection("Messages")
        .doc(messageId)
        .update({
      'reaction': reaction,
    });
  }
}
