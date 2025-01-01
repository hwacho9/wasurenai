import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasurenai/models/user_mode.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(uid: user.uid, email: user.email);
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(result.user);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore에 사용자 정보 저장
      await _firestore.collection('Users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'email': result.user!.email,
      });

      return _userFromFirebase(result.user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }
}
