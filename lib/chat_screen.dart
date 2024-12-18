import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatScreen extends StatefulWidget {
  final String chatRoomName;

  ChatScreen({required this.chatRoomName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // chatRoomNameが空であればエラーメッセージを表示する
    if (widget.chatRoomName.isEmpty) {
      // 必要に応じてエラーハンドリングを追加
      print("Error: Chat room name is empty.");
      // 必要ならエラーダイアログを表示するなど
    }
  }

  Future<void> _sendMessage() async {
  if (_messageController.text.isNotEmpty) {
    final user = _auth.currentUser;
    // chatRoomNameが空でないことを確認
    if (user != null && widget.chatRoomName.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(widget.chatRoomName) // チャットルーム名が空でないことを確認
          .collection('messages')
          .add({
        'text': _messageController.text,
        'sender': user.email,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    } else {
      // chatRoomNameが空の場合のエラーハンドリング
      print("Error: Chat room name is empty.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chat room name is missing')),
      );
    }
  }
}


 StreamBuilder<QuerySnapshot> _buildMessageStream() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.chatRoomName) // チャットルーム名でフィルタリング
        
        .collection('messages')
        .orderBy('timestamp') // 時間順に並べる
        .snapshots(),
        
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
        
      }
      final messages = snapshot.data!.docs;
      return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            title: Text(message['sender']),
            subtitle: Text(message['text']),
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomName),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageStream()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
