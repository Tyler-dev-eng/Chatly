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
              .map((doc) => _buildMessageItem(context, doc))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(BuildContext context, DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String currentUserId = _authService.currentUser!.uid;
    final theme = Theme.of(context);

    // sender is stored as 'id' in Firestore
    bool isCurrentUser = data['id'] == currentUserId;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isCurrentUser ? 48 : 8,
          right: isCurrentUser ? 8 : 48,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? theme.colorScheme.primary
              : theme.colorScheme.tertiary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
            bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
          ),
        ),
        child: Text(
          data['message'] ?? '',
          style: TextStyle(
            color: isCurrentUser
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onTertiary,
          ),
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
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
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: () => sendMessage(context),
              icon: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
