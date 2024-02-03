import 'package:come2werk_flutter/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:come2werk_flutter/screens/MyBluetoothPage.dart';
import 'package:come2werk_flutter/screens/MyAttendancePage.dart';
import 'package:permission_handler/permission_handler.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final welcomeBack = Text(
      "Welcome Back",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  child: Image.asset(
                    "assets/profilepic.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 50),
                welcomeBack,
                ConnectionsButton(),
                AttendanceButton(),
                SizedBox(height: 150), // Added space between buttons and sign out button
                SignOutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConnectionsButton extends StatelessWidget {
  const ConnectionsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BlueScreen()),
          );
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(8.0), // Added padding for spacing
            width: 1000,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.bluetooth,
                  color: Colors.blue, // You can customize the color
                ),
                SizedBox(width: 8.0), // Added space between icon and text
                Text('Connections'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AttendanceButton extends StatelessWidget {
  const AttendanceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AttendanceScreen()),
          );
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(8.0), // Added padding for spacing
            width: 1000,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.green, // You can customize the color
                ),
                SizedBox(width: 8.0), // Added space between icon and text
                Text('Attendance'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
          // Add sign-out logic here
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // Set button color to red
        ),
        child: Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
      ),
    );
  }
}
