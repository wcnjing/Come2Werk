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
    return Scaffold(
      appBar: AppBar(title: Text('HomePage'),),
      body: Center(
        child: Text('Welcome back, Jeremy Chan!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold
          ),
        ),
      ),

    );
  }
}


