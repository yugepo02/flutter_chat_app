import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart'; // チャット画面
import 'login_screen.dart'; // ログイン画面

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebaseの初期化
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthWrapper(),
    );
  }
}



// ログイン状態によって画面を切り替えるクラス
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // ローディング画面
        }
        if (snapshot.hasData) {
          return ChatScreen(chatRoomName: '',); // ログイン済みならチャット画面へ
        }
        return LoginScreen(); // 未ログインならログイン画面へ
      },
    );
  }
}
