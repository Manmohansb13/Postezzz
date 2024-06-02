import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userCollection=FirebaseFirestore.instance.collection("Users");

  final useremail=FirebaseAuth.instance.currentUser!;


  Future<void> editField (String field) async {
    String newValue="";
    await showDialog(context: context, builder: (context)=>AlertDialog(
      backgroundColor: Colors.grey[700],
      title: Text("Edit "+field,style: TextStyle(color: Colors.white),),
      content: TextField(
        autofocus: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Enter new "+field,
          hintStyle: TextStyle(color: Colors.grey),
        ),
        onChanged: (value){
          newValue=value;
        },
      ),
      actions: [
        TextButton(
            onPressed: ()=> Navigator.pop(context),
            child: Text("Cancel",style: TextStyle(color: Colors.white),
            )
        ),

        TextButton(
            onPressed: ()=> Navigator.of(context).pop(newValue),
            child: Text("Save",style: TextStyle(color: Colors.white),
    )

        )],


    ));

    // Saving Changes to firestore
    print(newValue);
    if(newValue.trim().length>0){
      await userCollection.doc(useremail.email).update({field: newValue});
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile page"),
        backgroundColor: Colors.blueGrey,
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(useremail.email).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            final userData=snapshot.data!.data() as Map<String,dynamic>;
            return ListView(
              children: [
                SizedBox(height: 50,),
                Icon(Icons.person,size: 100,),
                SizedBox(height: 20,),

                Text(useremail.email!,textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[700],fontSize: 22),),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text("My Details",style: TextStyle(color: Colors.grey[600],fontSize: 20),),
                ),
                SizedBox(height: 20,),
                MyTextBox(sectionName: "Username", text: userData["username"],onPressed: ()=> editField("username"),),
                SizedBox(height: 20,),
                MyTextBox(sectionName: "Bio", text: userData["bio"],onPressed: ()=> editField("bio"),),
              ],
            );
          }
          else if(snapshot.hasError){
            return Center(
              child: Text("Error${snapshot.error}"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      )
    );
  }
}
