import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/comment.dart';
import 'package:login/components/comment_button.dart';
import 'package:login/components/like_button.dart';

import '../helper_method/formatDate.dart';

class displayPost extends StatefulWidget {
  final String message;
  final String timeStamp;
  final String user;
  final String postId;
  final List<String> likes;
  const displayPost({super.key,required this.user,required this.message,required this.postId,required this.likes,required this.timeStamp});

  @override
  State<displayPost> createState() => _displayPostState();
}

class _displayPostState extends State<displayPost> {
  final currentUser=FirebaseAuth.instance.currentUser!;
  bool isLiked=false;
  final _commenttcontroller=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked=widget.likes.contains(currentUser.email);
  }

  void toggleLike(){
    setState(() {
      isLiked= !isLiked;
    });
    DocumentReference postRef=FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if(isLiked){
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email]),
      });
    }
    else{
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email]),
      });
    }
}
// comment
  void addComment(String commentText){
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").add(
        {
          "CommentText":commentText,
          "Commentedby":currentUser.email,
          "TimeStamp":Timestamp.now(),
        });
  }


//Comment Dialog box
  void CommentDailog(){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text("Add Comment"),
      content: TextField(
        controller: _commenttcontroller,
        decoration: InputDecoration(
          hintText: "Write a comment",
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
          _commenttcontroller.clear();
        },
            child: Text("Cancel"),
        ),
        TextButton(
            onPressed: (){
          addComment(_commenttcontroller.text);
          _commenttcontroller.clear();
        }, child: Text("Post")),
      ],
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(top: 25,left: 25,right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

             //Message
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(child: Text(widget.message)),

                  Text(widget.timeStamp),
                ],
              ),
              SizedBox(height: 10,),
              //User who posted
              Text(widget.user,style: TextStyle(color: Colors.grey[600]),),

            ],
          ),
          SizedBox(height: 10,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //Like Button
              Column(
                children: [
                  likeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 5,),
                  Text(widget.likes.length.toString(),style: TextStyle(color: Colors.grey),),
                ],
              ),

              SizedBox(width: 15,),

              //Comment button
              Column(
                children: [
                  CommentButton(onTap: CommentDailog),
                  const SizedBox(height: 5,),

                ],
              ),
            ],
          ),


          //Displaying Comments-----

          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments").orderBy("TimeStamp",descending: true).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  shrinkWrap: true,//For nested list
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc){
                    //get the comment
                    final commentData=doc.data() as Map<String,dynamic>;
                    //return the comment
                    return Comment(
                        text: commentData["CommentText"],
                        user: commentData["Commentedby"],
                        time: formatDate(commentData["TimeStamp"]),
                    );

                  }).toList(),
                );
              }
          ),
        ],
      ),
    );
  }
}
