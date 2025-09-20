import 'package:flutter/material.dart';
import 'package:minimalist_chat/services/auth/auth_service.dart';
import 'package:minimalist_chat/components/my_textfield.dart';
import 'package:minimalist_chat/components/my_button.dart';

class RegisterPage extends StatelessWidget {
  //Email and Pw text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

//Tap to go to Login Page
  final void Function()? oneTap;

  RegisterPage({super.key,required this.oneTap});

  //Register Method

  void register(BuildContext context) async {
    //get auth service
    final _auth = AuthService();

    //passwords match -> create user
    if (_pwController.text == _confirmPwController.text) {
      try {
      // Espera a que el usuario se cree en Firebase
      await _auth.signUpWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
      // Opcional: muestra un mensaje de éxito o navega a otra pantalla
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
        title: Text("Registration successful! :D"),
        ),
      );
      }
      catch(e){
        showDialog(
          context: context, 
          builder: (context)=>AlertDialog
          (title:Text(e.toString()),
          )
        );
      }
    }
    //passwords do not match -> tell user to fix
    else{
      showDialog(
          context: context, 
          builder: (context)=>const AlertDialog
          (title:Text("Passwords don't match!"),
          )
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),
            //welcome Back Message
            Text(
              'Let`s create an account for you',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),
            //Email textfield
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            //Pw textfield
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

             const SizedBox(height: 10),

            //ConfirmPw textfield
            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _confirmPwController,
            ),

            const SizedBox(height: 25),

            //Login Button
            MyButton(text: "Register", onTap:()=>register(context)),

            const SizedBox(height: 25),

            //Register Now
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Text("Already have an account?",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: oneTap,
                  child: Text("Login now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary
                  ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
