import 'package:chatly/components/my_textfield.dart';
import 'package:chatly/services/chat/chat_services.dart';
import 'package:chatly/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverId;
  ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  // text controller
  final TextEditingController messageController = TextEditingController();

  // chat and auth service
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  // send message
  void sendMessage(BuildContext context) async {
    try {
      if (messageController.text.isNotEmpty) {
        await _chatServices.sendMessage(receiverId, messageController.text);
        messageController.clear();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with $receiverEmail')),
      body: Column(
        children: [
          // display all messages
          Expanded(child: _buildMessageList()),

          // user input
          _buildMessageInput(context),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    String currentUserId = _authService.currentUser!.uid;
    return StreamBuilder(
      stream: _chatServices.getMessages(currentUserId, receiverId),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // return message list
        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data['message']);
  }

  // build message input
  Widget _buildMessageInput(BuildContext context) {
    return Row(
      children: [
        // textfield should take up most of the space
        Expanded(
          child: MyTextField(
            controller: messageController,
            hintText: 'Type your message here...',
            isPassword: false,
          ),
        ),

        // send button
        IconButton(onPressed: () => sendMessage(context), icon: Icon(Icons.send)),
      ],
    );
  }
}
