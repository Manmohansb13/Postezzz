import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/components/drawer.dart';
import 'package:login/profile_page.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  void goToProfilePage(){
    Navigator.pop(context);
    Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout)),
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onsignout: signOut,
      ),

    );
  }
}
