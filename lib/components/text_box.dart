import 'package:flutter/material.dart';


class MyTextBox extends StatelessWidget {
  final String sectionName;
  final String text;
  final void Function()? onPressed;
  const MyTextBox({super.key,required this.sectionName,required this.text,required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12)

      ),
      padding: EdgeInsets.only(left: 15,bottom: 15),
      margin: EdgeInsets.only(left: 15,right: 15,top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionName,style: TextStyle(fontSize: 20,color: Colors.grey[600]),),
              IconButton(onPressed: onPressed, icon: Icon(Icons.settings)),
            ],
          ),
          Text(text,style: TextStyle(fontSize: 20),),

        ],
      ),
    );
  }
}
