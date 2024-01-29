import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlueScreen extends StatefulWidget {
  const BlueScreen({super.key});

  @override
  _BlueScreenState createState() => _BlueScreenState();
}
class _BlueScreenState extends State<BlueScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final welcomeback = Text("Welcome Back, Jeremy Chan!",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),);
    return Scaffold();
  }
}