import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prac_app/screens/Homescreen.dart';
import 'package:prac_app/services/auth_services.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("LOGIN / SIGN UP"),
              Container(
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "EMAIL...",
                  ),
                ),
              ),
              Container(
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "PASSWORD...",
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: Colors.blue,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ) ,
                  onPressed: () {
                    final String email = emailController.text.trim();
                    final String password = passwordController.text.trim();
                    if(email.isEmpty){
                      print("Email is Empty");
                    } else {
                      if(password.isEmpty){
                        print("Password is Empty");
                      } else {
                        context.read<AuthService>().login(
                          email,
                          password,
                        );
                      }
                    }
                  },
                  child: Text("LOG IN"),
                ),
              ),SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width ,
                color: Colors.red,
                child: ElevatedButton(
                  onPressed: () {
                    final String email = emailController.text.trim();
                    final String password = passwordController.text.trim();

                    if(email.isEmpty){
                      print("Email is Empty");
                    } else {
                      if(password.isEmpty){
                        print("Password is Empty");
                      } else {
                        context.read<AuthService>().signUp(
                          email,
                          password,
                        ).then((value) async {
                          User user = FirebaseAuth.instance.currentUser;

                          await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
                            'uid': user.uid,
                            'email': email,
                            'password': password,
                          });
                        });
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      }
                    }
                  },
                  child: Text("SIGN UP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}