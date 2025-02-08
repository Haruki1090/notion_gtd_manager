import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google アカウントでサインイン
  Future<User?> signInWithGoogle() async {
    // Google サインインフローを開始
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // ユーザーがサインインをキャンセルした場合は null を返す
      return null;
    }

    // Google 認証情報を取得
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Firebase 用にクレデンシャルを生成
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // クレデンシャルを使用して Firebase でサインイン
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  // メール/パスワードでの新規登録
  Future<User?> registerWithEmailPassword(String email, String password) async {
    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // サインアウト処理
  Future<void> signOut() async {
    // Firebase でサインアウト
    await _auth.signOut();
    // Google サインインでサインアウト
    await _googleSignIn.signOut();
  }
}
