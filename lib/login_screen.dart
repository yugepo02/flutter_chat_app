import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'chatroom_screen.dart'; // チャットルーム一覧画面

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;

  // Googleでサインイン
  Future<void> _signInWithGoogle() async {
    try {
      // Googleサインイン
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // ユーザーがサインインをキャンセルした場合
        return;
      }

      // Googleの認証情報を取得
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebaseの認証情報を作成
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebaseにサインイン
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      setState(() {
        _user = user;
      });

      // ログイン後にチャットルーム一覧画面に遷移
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatRoomListScreen()), // ログイン後に遷移する画面
        );
      }

    } catch (e) {
      print('Google sign-in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed. Please try again.')),
      );
    }
  }

  // サインアウト処理
  Future<void> _signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Sign-In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _user == null
                ? ElevatedButton(
                    onPressed: _signInWithGoogle,
                    child: Text('Sign in with Google'),
                  )
                : Column(
                    children: [
                      Text('Signed in as ${_user!.displayName}'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _signOut,
                        child: Text('Sign out'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
