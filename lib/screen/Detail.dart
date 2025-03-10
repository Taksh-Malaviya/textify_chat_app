import 'dart:developer';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/fcm_service.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modal/user_model.dart';
import '../modal/message_model.dart';

class DetailPage extends StatelessWidget {
  DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel receiver = Get.arguments;
    final String senderId = AuthService.authService.currentUser!.email ?? "";
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          receiver.name,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: FireStoreService.fireStoreService
                  .fetchMessages(senderId, receiver.email),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<MessageModel> messages = snapshot.data!;
                MessageModel? previousMessage;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    MessageModel msg = messages[index];
                    bool isMe = msg.senderId == senderId;

                    bool showDateChip = previousMessage == null ||
                        _isDifferentDay(
                            previousMessage!.timestamp, msg.timestamp);

                    previousMessage = msg;

                    return Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (showDateChip)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Chip(
                                label: Text(
                                  _formatDate(msg.timestamp),
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.blueAccent,
                              ),
                            ),
                          ),
                        GestureDetector(
                          onLongPress: () {
                            _showMessageOptions(
                                context, msg, senderId, receiver.email);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            padding: const EdgeInsets.all(12),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? (isDarkMode
                                      ? Colors.blue.shade700
                                      : Colors.blue)
                                  : (isDarkMode
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade300),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: isMe
                                    ? const Radius.circular(12)
                                    : const Radius.circular(0),
                                bottomRight: isMe
                                    ? const Radius.circular(0)
                                    : const Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.message,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isMe
                                        ? Colors.white
                                        : (isDarkMode
                                            ? Colors.white70
                                            : Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Text(
                                _formatTimestamp(msg.timestamp),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade500),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                msg.status == "seen"
                                    ? Icons.done_all
                                    : msg.status == "delivered"
                                        ? Icons.done_all
                                        : Icons.check,
                                size: 16,
                                color: msg.status == "seen"
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(context, senderId, receiver.email, receiver.token)
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  String _formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
  }

  bool _isDifferentDay(Timestamp previous, Timestamp current) {
    DateTime prevDate = previous.toDate();
    DateTime currDate = current.toDate();
    return prevDate.year != currDate.year ||
        prevDate.month != currDate.month ||
        prevDate.day != currDate.day;
  }

  void _showMessageOptions(BuildContext context, MessageModel msg,
      String senderId, String receiverId) {
    if (senderId != msg.senderId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only delete your own messages")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Edit Message"),
                onTap: () {
                  Navigator.pop(context);
                  _showEditMessageDialog(context, msg, senderId, receiverId);
                },
              ),
              ListTile(
                title: Text("Delete Message"),
                onTap: () async {
                  Navigator.pop(context);
                  if (senderId == msg.senderId) {
                    await FireStoreService.fireStoreService.deleteChat(
                      sender: senderId,
                      receiver: receiverId,
                      id: msg.id,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditMessageDialog(BuildContext context, MessageModel msg,
      String senderId, String receiverId) {
    TextEditingController controller = TextEditingController(text: msg.message);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Message"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Edit your message"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String updatedMessage = controller.text.trim();
                if (updatedMessage.isNotEmpty) {
                  await FireStoreService.fireStoreService.updateMessage(
                    messageId: msg.id,
                    updatedMessage: updatedMessage,
                    senderId: senderId,
                    receiverId: receiverId,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessageInput(BuildContext context, String senderId,
      String receiverId, String receiverToken) {
    final TextEditingController msgController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: msgController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () async {
              if (msgController.text.trim().isEmpty) return;

              String messageText = msgController.text.trim();
              msgController.clear();

              MessageModel newMessage = MessageModel(
                id: "",
                senderId: senderId,
                receiverId: receiverId,
                message: messageText,
                timestamp: Timestamp.now(),
                status: "sent",
              );

              await FireStoreService.fireStoreService
                  .sendMessage(
                receiverId: receiverId,
                senderId: senderId,
                message: messageText,
              )
                  .then(
                (value) async {
                  await FCMService.fcmService.sendFCM(
                      title: senderId, body: messageText, token: receiverToken);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
