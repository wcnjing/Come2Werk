import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final welcomeback = Text("Welcome Back, Jeremy Chan!",
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),);



    return Scaffold(
    body: Center(
          child:SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height:200,
                    child: Image.asset("assets/profilepic.png",
                    fit:BoxFit.contain,)
                  ),
                  SizedBox(height:50),
                  welcomeback,

                ],

              ),
              ),
            ),
          ),
          ),
      );
  }


  }



