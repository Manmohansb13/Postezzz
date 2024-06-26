import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comment({super.key,required this.text,required this.user,required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey[300],
      ),
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          SizedBox(height: 5,),

          Row(
            children: [
              Text(user,style: TextStyle(color: Colors.grey[500]),),
              Text("  .  ",style: TextStyle(color: Colors.grey[500]),),
              Text(time,style: TextStyle(color: Colors.grey[500]),),
            ],
          )
        ],
      ),
    );
  }
}
