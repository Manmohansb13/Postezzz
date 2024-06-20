import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/auth/auth.dart';
import 'package:login/auth/register_or_login.dart';
import 'package:login/firebase_options.dart';
import 'package:login/register_page.dart';

import 'home.dart';
import 'login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/':(context)=>AuthPage(),
      // '/login':(context)=>login(),
    },

  ));
}

