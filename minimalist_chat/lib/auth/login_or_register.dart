import 'package:flutter/widgets.dart';
import 'package:minimalist_chat/pages/login_page.dart';
import 'package:minimalist_chat/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initiality, show login page
  bool showLoginPage = true;

  //toggle between Login and Register Page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(oneTap: togglePages);
    } else {
      return RegisterPage(oneTap: togglePages);
    }
  }
}
