import 'package:flutter/material.dart';
import 'package:login/components/my_list_tile.dart';


class MyDrawer extends StatelessWidget {
  final void Function() ? onProfileTap;
  final void Function() ? onsignout;
  const MyDrawer({super.key,required this.onProfileTap,required this.onsignout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Column(
            children: [
              DrawerHeader(
                child: Icon(Icons.person,color: Colors.white,size: 70,),
              ),
              SizedBox(height: 10,),
              //home listtile
              MyListTile(icon: Icons.home, text:"H O M E",onTap:()=> Navigator.pop(context),),
              SizedBox(height: 10,),
              //profile listtile
              MyListTile(icon: Icons.person, text: "P R O F I L E", onTap:onProfileTap),
              SizedBox(height: 10,),
            ],
          ),

          //Signout
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListTile(icon: Icons.logout, text: "S I G N  O U T", onTap:onsignout),
          ),


        ],
      ),


    );
  }
}
