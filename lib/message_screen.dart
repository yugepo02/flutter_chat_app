import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String sender;  // 送信者の名前（またはメール）
  final bool isCurrentUser;  // 現在のユーザーかどうか

  // コンストラクタで送信者情報とメッセージのテキストを受け取る
  ChatMessage({required this.text, required this.sender, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,  // 現在のユーザーなら右寄せ
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.green : Colors.blueAccent,  // 現在のユーザーは緑、その他は青
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sender,  // 送信者名を表示
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                text,  // メッセージの内容を表示
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
