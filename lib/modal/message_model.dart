import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String? reaction;
  String status;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.reaction,
    this.status = "sent",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'reaction': reaction ?? "",
      'status': status,
    };
  }

  factory MessageModel.fromMap(String docId, Map<String, dynamic> map) {
    return MessageModel(
      id: docId,
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      reaction: map['reaction'] ?? "",
      status: map['status'] ?? "sent",
    );
  }
}
