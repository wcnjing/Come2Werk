import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  Set<DateTime> _highlightedDates = {}; // Set to store highlighted dates

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 30));
    _lastDay = DateTime.now().add(const Duration(days: 30));

    DatabaseReference testRef = FirebaseDatabase.instance.ref().child('Attendance');
    testRef.onValue.listen((event) {
      try {
        DataSnapshot dataSnapshot = event.snapshot;

        // Check if the data is not null and is of Map type
        if (dataSnapshot.value is Map<dynamic, dynamic>?) {
          // Use the null-aware operator to handle nullability
          Map<dynamic, dynamic>? data = dataSnapshot.value as Map<dynamic, dynamic>?;

          if (data != null) {
            Set<DateTime> highlightedDates = data.entries
                .where((entry) =>
            entry.value is Map &&
                entry.value.containsKey('checkIn') &&
                entry.value['checkIn'] == true)
                .map((entry) => DateTime.parse(entry.key))
                .toSet();

            setState(() {
              _highlightedDates = highlightedDates;
            });
          }
        } else {
          print('Invalid data format received from Firebase.');
        }
      } catch (e) {
        print('Error loading data from Firebase: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              // Return true if the day is selected or highlighted
              return isSameDay(_selectedDate, day) || _highlightedDates.contains(day.toLocal());
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _focusedDay = focusedDay; // Update focused day as well
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Colors.blueAccent, // Selected color
                shape: BoxShape.circle,
              ),
              todayDecoration: const BoxDecoration(
                color: Colors.blue, // Today's color
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Selected Date: ${_selectedDate.toString().split(' ')[0]}', // Display date in 'YYYY-MM-DD' format
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Check if today's date is selected before allowing check-in
              if (isSameDay(_selectedDate, DateTime.now())) {
                DatabaseReference attendanceRef = FirebaseDatabase.instance.ref().child('Attendance');
                attendanceRef.child(_selectedDate.toString().split(' ')[0]).once().then((snapshot) {
                  if (snapshot != null &&
                      snapshot.snapshot.value != null &&
                      (snapshot.snapshot.value as Map)['checkIn'] == true) {
                    // If the date is already checked in, remove it from both local set and Firebase
                    _highlightedDates.remove(_selectedDate.toLocal());
                    attendanceRef.child(_selectedDate.toString().split(' ')[0]).remove();
                  } else {
                    // Show the dialog for Gantry selection
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Select Gantry'),
                          content: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  handleGantrySelection('A');
                                },
                                child: const Text('Gantry A'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  handleGantrySelection('B');
                                },
                                child: const Text('Gantry B'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  handleGantrySelection('C');
                                },
                                child: const Text('Gantry C'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }).catchError((error) {
                  print('Failed to check attendance: $error');
                });
              } else {
                // Display a message or take appropriate action for an invalid date
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Invalid Date'),
                      content: const Text('You can only check in on today\'s date.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Check In'),
          ),

          const SizedBox(height: 20),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16), // Adjust margin as needed
            color: Colors.white, // Set background color to white
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Days clocked in: ${countHighlightedDays()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Days absent: ${countNonHighlightedDays()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void handleGantrySelection(String gantry) {
    // Perform actions based on the selected gantry
    print('Selected Gantry: $gantry');

    // Add or update the check-in status in Firebase with the selected gantry
    DatabaseReference attendanceRef = FirebaseDatabase.instance.ref().child('Attendance');
    attendanceRef.child(_selectedDate.toString().split(' ')[0]).set({
      'checkIn': true,
      'gantry': gantry,
    });

    // Toggle highlighting of selected date
    _highlightedDates.add(_selectedDate.toLocal());

    Navigator.pop(context); // Close the dialog

    // Show "Please scan your card now" message with a delay
    Fluttertoast.showToast(
      msg: 'Please scan your card now',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );

    // Introduce a delay before showing the "Check-in successful" toast
    Future.delayed(const Duration(seconds: 5), () {
      // Show "Check-in successful" toast
      Fluttertoast.showToast(
        msg: 'Check-in successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });

    setState(() {}); // Update the UI
  }


  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int countHighlightedDays() {
    DateTime startOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    int count = 0;
    for (DateTime date in _highlightedDates) {
      if ((date.isAfter(startOfMonth) || date == (startOfMonth)) && date.isBefore(DateTime.now())) {
        count++;
      }
    }
    return count;
  }

  int countNonHighlightedDays() {
    DateTime firstDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    int totalDays = firstDayOfMonth.difference(DateTime.now()).inDays.abs() +1;

    return totalDays - countHighlightedDays();
  }
}
