import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/components/display_post.dart';
import 'package:login/components/drawer.dart';
import 'package:login/profile_page.dart';

import 'helper_method/formatDate.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  final currentUser=FirebaseAuth.instance.currentUser!;
  final TextEditingController _controller = TextEditingController();
  void goToProfilePage(){
    Navigator.pop(context);
    Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfilePage()));
  }

  //Post Messages
  void toPost(){
    if(_controller.text.isNotEmpty){
      DateTime now = DateTime.now();
      int timestamp = now.millisecondsSinceEpoch ~/ 1000;  // Convert milliseconds to seconds
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail":currentUser.email,
        "Message":_controller.text,
        "TimeStamp":Timestamp.now(),
        "Likes":[],
      });
    }
    setState(() {
      _controller.clear();
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueGrey,

      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onsignout: signOut,
      ),

      body: Column(
        children: [
          //Retrive
          Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("User Posts").orderBy("TimeStamp",descending: false).snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data!.docs. length,
                        itemBuilder: (context,index){
                      //get the messages

                      final post=snapshot.data!.docs[index];
                      return displayPost(
                        user: post['UserEmail'],
                        message: post["Message"],
                        postId: post.id,
                        likes: List<String>.from(post["Likes"] ?? []),
                        timeStamp: formatDate(post["TimeStamp"]),
                      );
                    });
                  }
                  else if(snapshot.hasError){
                    return Center(
                      child: Text("Error:${snapshot.error}"),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  
                },
              )
          ),


          //Posting
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Write something to share",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )
                    ),

                  ),
                ),
                IconButton(onPressed: toPost, icon: Icon(Icons.arrow_circle_up_rounded)),
              ],
            ),
          ),

          //Current user
          Text("Logged in as: "+currentUser.email!),

          SizedBox(height: 50,),
          
          
        ],
      ),

    );
  }
}
