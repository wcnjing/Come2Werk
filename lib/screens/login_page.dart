import 'package:come2werk_flutter/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth.dart';


class LoginScreen extends StatefulWidget {

  LoginScreen({ Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
}

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // email field
    final emailField = TextFormField(

      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      // validator: () {},
      onSaved: (value)
      {
        emailController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20,15,20,15),
        hintText: "Email",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
        ),
      ));

    // password field
        final passwordField = TextFormField(

          autofocus: false,
          controller: passwordController,
          obscureText: true,
          // validator: () {},
          onSaved: (value)
          {
            passwordController.text = value!;
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  contentPadding: EdgeInsets.fromLTRB(20,15,20,15),
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                  ),
                ));

          final loginButton = Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.blueAccent,
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(20,15,20,15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text("Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: SingleChildScrollView(
                    child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(36.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,

                                  children: <Widget>[
                                    SizedBox(
                                        height:200,
                                        child: Image.asset("assets/logo.jpg",
                                        fit:BoxFit.contain,
                                        )
                                    ),
                                    SizedBox(height: 45),

                                    emailField,
                                    SizedBox(height: 25),
                                    passwordField,
                                    SizedBox(height: 35),
                                    loginButton,
                                    SizedBox(height: 15),
                                  ],
                              ),
                          ),
                        ),
                    ),
                ),
            ),
        );
  }
}