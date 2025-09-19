import 'package:firebase_auth/firebase_auth.dart';
class AuthService {

  // instance of auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? get currentUser(){
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
        });

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
          'email': email,
          'uid': userCredential.user!.uid,
        });


      return userCredential;
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut()async{
    return await _auth.signOut();
  }
  //errors

}