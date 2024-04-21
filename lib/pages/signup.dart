import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/providers/user_provider.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signInKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp( r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Form(
        key: _signInKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const FaIcon(
            FontAwesomeIcons.twitter,
            color: Colors.blue,
            size: 70
            ,),
          // const Image(
          //   image: AssetImage('assets/twitter_blue.png'),
          //   width: 100,
          //   ),
             const SizedBox(
              height: 20,
             ),
          const Text(
            "Sign up To Twitter",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin:const EdgeInsets.fromLTRB(15, 30, 15, 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
                ) ,
            
            child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter an Email",
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
            validator: (value){
              if(value == null || value.isEmpty){
                return "Please enter an Email";
              }else if(!emailValid.hasMatch(value)){
                return "Please Enter a Valid Email";
              }
              return null;
              },
            ),
            ),//emial
            Container(
              margin:const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
                ) ,

              child: TextFormField(  
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Enter a Password",
                 border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Please enter a Password";
                }else if(value.length <6){
                  return "Password must be atleast 6 characters";
                }
                return null;
                },
              ),
            ),//Password
            Container(
              width: 250,
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: TextButton(
              onPressed: () async{
              if(_signInKey.currentState!.validate()){
              try{
                await _auth.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text
                  );
                  await ref
                  .read(userProvider.notifier)
                  .signUp(_emailController.text);
                  if(!mounted) return;
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
              }catch(e){
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
              }
              
                },
              child: const Text("Sign Up",style: TextStyle(color: Colors.white, fontSize: 18),)),
            ),
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            },
             child: const Text("Already have an account? Log in"))
          ],
        
        ),
      ),
    );

  }
}