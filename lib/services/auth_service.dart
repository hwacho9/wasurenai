import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Future<void> deleteAccount(String password) async {
    final user = _auth.currentUser;

    if (user != null) {
      final userId = user.uid;

      try {
        // 사용자 재인증
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);

        // Firestore 논리 삭제
        await _firestore.collection('Users').doc(userId).set(
          {
            'isDeleted': true,
            'deletedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        // Firebase Auth 계정 삭제
        await user.delete();

        debugPrint('사용자 계정 삭제 완료');
      } catch (e) {
        throw Exception('Failed to delete user: $e');
      }
    } else {
      throw Exception('No user is currently signed in');
    }
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }
}
