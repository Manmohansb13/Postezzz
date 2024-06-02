import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/set_controller.dart';
import 'package:rive/rive.dart';

class login extends StatefulWidget {
  final Function()? onTap;
  const login({super.key,required this.onTap});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  StateMachineController ? controller;
  SMIInput<bool> ? isChecking;
  SMIInput<bool> ? isHandsUp;
  SMIInput<bool> ? trigSuccess;
  SMIInput<bool> ? trigFail;
  final emailTextController=TextEditingController();
  // late final TextEditingController c;
  String _email="";
  String _password="";



  void signIn() async{
    showDialog(
        context: context,
        builder: (context)=>Center(
          child: CircularProgressIndicator(),
        ));

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      // Pop loading Circle
      if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch(e){
      // pop loading circle
      Navigator.pop(context);
      // Display error messages
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
    final Size size =MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffD6E2EA),
      body: Container(
        width: size.width,
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width,
                height: 200.0,
                child: RiveAnimation.asset(
                  'ass/animated_login_character.riv',
                  stateMachines: ["Login Machine"],
                  onInit: (artboard){
                    controller=StateMachineController.fromArtboard(artboard,"Login Machine");
                    if(controller==null) return;
                    artboard.addController(controller!);
                    isChecking=controller?.findInput("isChecking");
                    isHandsUp=controller?.findInput("isHandsUp");
                    trigSuccess=controller!.findInput("trigSuccess")!;
                    trigFail=controller!.findInput("trigFail")!;
                  },
                ),
              ),
              SizedBox(height: 10,),

              TextField(
                onChanged: (value){
                  setState(() {
                    _email=value;
                  });
                  print(_email);
                  if(isHandsUp != null){
                    isHandsUp!.change(false);
                  }
                  if(isChecking==null) return;
                  isChecking!.change(true);
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
                  _password=value;
                  if(isChecking != null){
                    isChecking!.change(false);
                  }
                  if(isHandsUp==null) return;
                  isHandsUp!.change(true);
                  print(_password);
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
              SizedBox(height: 10,),

              GestureDetector(
                onTap: (){},
                child: Align(
                  alignment: Alignment.topRight,
                    child: Text("Forget your Password?",style: TextStyle(color: Colors.indigoAccent,fontSize: 16),)
                ),
              ),

              SizedBox(height: 15,),

              MaterialButton(
                onPressed: signIn,
                minWidth: size.width,
                height: 50,


                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                  child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
              ),

              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't you have an account?"),
                  TextButton(
                      onPressed: widget.onTap,
                      child: Text("Register",style: TextStyle(color: Colors.indigoAccent,fontWeight: FontWeight.bold),)),
                ],
              ),




            ],
          ),
        ),

      ),);
  }
}
