import 'package:come2werk_flutter/screens/home_page.dart';
import 'package:come2werk_flutter/screens/login_page.dart';
import 'package:come2werk_flutter/screens/MyBluetoothPage.dart';
import 'package:come2werk_flutter/screens/MyAttendancePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
  @override
  Widget hScreen(BuildContext context){
    return MaterialApp(
      title: 'Home Page',
      home: HomeScreen(),
    );
  }
  @override
  Widget bScreen(BuildContext context){
    return MaterialApp(
      title: 'Bluetooth Page',
      home: BlueScreen(),
    );
  }

  @override
  Widget aScreen(BuildContext context){
    return MaterialApp(
      title: 'Attendance Page',
      home: AttendanceScreen(),
    );
  }
}
