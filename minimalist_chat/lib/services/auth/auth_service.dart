import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  // instance of auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential>signInWithEmailAndPassword(String email, password) async{
    try{
      //sign user in
      UserCredential userCredential= await _auth.signInWithEmailAndPassword(email: email, password:password);
      
      //Guarda la información del usuario si aún no existe.
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'email': email,
          'uid': userCredential.user!.uid,
        },
        SetOptions(merge: true),
      );

      return userCredential;
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }


  }
  // sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async{
    try{
      //create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,
        );


        //save user info in a separate doc
        _firestore.collection("Users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'displayName': email.split('@')[0], // initially set display name to username part of email
        });


      return userCredential;
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  // update user profile
  Future<void> updateUserProfile({String? displayName}) async {
    final user = getCurrentUser();
    if (user == null) return;

    try {
      Map<String, dynamic> dataToUpdate = {};
      if (displayName != null) {
        dataToUpdate['displayName'] = displayName;
      }

      if (dataToUpdate.isNotEmpty) {
        await _firestore.collection("Users").doc(user.uid).update(dataToUpdate);
      }
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  // get all users stream, excluding current user
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    final currentUser = getCurrentUser();
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs
        .map((doc) => doc.data())
        .where((userData) => userData['uid'] != currentUser?.uid)
        .toList();
    });
  }

  //sign out
  Future<void> signOut()async{
    return await _auth.signOut();
  }
  //errors

}