import 'package:come2werk_flutter/screens/home_page.dart';
import 'package:come2werk_flutter/screens/login_page.dart';
import 'package:come2werk_flutter/screens/MyBluetoothPage.dart';
import 'package:come2werk_flutter/screens/MyAttendancePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
  @override
  Widget hScreen(BuildContext context){
    return const MaterialApp(
      title: 'Home Page',
      home: HomeScreen(),
    );
  }
  @override
  Widget bScreen(BuildContext context){
    return const MaterialApp(
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
