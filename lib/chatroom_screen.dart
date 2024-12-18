import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'create_chat_room_screen.dart'; 

class ChatRoomListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Rooms')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chat_rooms').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final chatRooms = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoomName = chatRooms[index]['name'];
              return ListTile(
                title: Text(chatRoomName),
                onTap: () {
                  // チャットルームが存在すれば、ChatScreenに遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatRoomName: chatRoomName),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 新しいチャットルーム作成画面に遷移
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateChatRoomScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}