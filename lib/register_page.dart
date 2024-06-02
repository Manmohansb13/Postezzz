import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _email="";
  String _password="";
  String _cpassword="";

  void signUp() async{
    showDialog(
        context: context,
        builder: (context)=>Center(
          child: CircularProgressIndicator(),
        ));
    if(_password!=_cpassword){
      Navigator.pop(context);
      displayMessage("Password doesn't match!!");
      return;
    }
    try{
      UserCredential userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
      //Creating data of the user in Firestore

      FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set(
        {
          'username':_email.split("@")[0],
          'bio':"empty bio....",
        }
      );




      if(context.mounted) Navigator.pop(context);
      
    } on FirebaseAuthException catch(e){
      Navigator.pop(context);
      displayMessage(e.code);
    }

  }

  void displayMessage(String message){
    showDialog(
        context: context,
        builder: (context)=> AlertDialog(
          title: Text(message.toUpperCase()),
        ));
  }


  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffD6E2EA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock,size: 100,),
                SizedBox(height: 15,),
                Text("Lets Create an Account For You",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
          SizedBox(height: 15,),

          TextField(
            onChanged: (value){
              setState(() {
                _email=value;
              });
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )
            ),
          ),
                SizedBox(height: 15,),
                TextField(
                  onChanged: (value){
                    setState(() {
                      _password=value;
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )
                  ),
                ),
                SizedBox(height: 15,),
                TextField(
                  onChanged: (value){
                    setState(() {
                      _cpassword=value;
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Confirm Password",
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )
                  ),
                ),
                SizedBox(height: 20,),
                MaterialButton(
                  onPressed: signUp,
                  minWidth: size.width,
                  child: Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 20),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.black,
                  height: 50,
                ),
                SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                        onPressed: widget.onTap,
                        child: Text("Login now",style:TextStyle(
                          color: Colors.indigoAccent,
                          fontWeight: FontWeight.bold,
                        ),))
                  ],
                )



              ],
            ),
          ),
        ),
      ),
    );
  }
}



