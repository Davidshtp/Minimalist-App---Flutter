import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimalist_chat/auth/login_or_register.dart';
import 'package:minimalist_chat/pages/home_page.dart';

class AuthGate extends StatelessWidget{
  const AuthGate ({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            //usser is logged in
            if(snapshot.hasData){
              return const HomePage();
            }

            // usser is NOT logged in
            else{
              return const LoginOrRegister();
            }
          }
        )

    );
  }
}