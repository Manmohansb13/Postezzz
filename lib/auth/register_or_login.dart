import 'package:flutter/material.dart';
import 'package:login/login.dart';
import 'package:login/register_page.dart';

class LoginorRegister extends StatefulWidget {
  const LoginorRegister({super.key});

  @override
  State<LoginorRegister> createState() => _LoginorRegisterState();
}

class _LoginorRegisterState extends State<LoginorRegister> {
  bool showLoginPage=true;
  void togglePages(){
    setState(() {
      showLoginPage= !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return login(onTap: togglePages);
    }
    else{
      return RegisterPage(onTap: togglePages);
    }

  }
}
