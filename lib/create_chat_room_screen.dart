import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateChatRoomScreen extends StatefulWidget {
  @override
  _CreateChatRoomScreenState createState() => _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
  final TextEditingController _roomNameController = TextEditingController();

  Future<void> _createChatRoom() async {
    final roomName = _roomNameController.text.trim();
    if (roomName.isNotEmpty) {
      // Firestoreに新しいチャットルームを作成
      await FirebaseFirestore.instance.collection('chat_rooms').add({
        'name': roomName,
      });
      // 作成後、ChatRoomListScreenに戻る
      Navigator.pop(context);
    } else {
      // 入力が空の場合、エラーメッセージを表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid room name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Chat Room')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _roomNameController,
              decoration: InputDecoration(labelText: 'Chat Room Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createChatRoom,
              child: Text('Create Room'),
            ),
          ],
        ),
      ),
    );
  }
}
