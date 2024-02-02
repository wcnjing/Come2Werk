import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  Set<DateTime> _highlightedDates = {}; // Set to store highlighted dates

  String realTimeValue = '';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(Duration(days: 30)); // Adjust as needed
    _lastDay = DateTime.now().add(Duration(days: 30)); // Adjust as needed

    DatabaseReference _testRef = FirebaseDatabase.instance.ref().child('Attendance');
    _testRef.onValue.listen((event) {
      try {
        DataSnapshot dataSnapshot = event.snapshot;
        Map<String, dynamic>? data = dataSnapshot.value as Map<String, dynamic>?;

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
      } catch (e) {
        print('Error loading data from Firebase: $e');
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              // Return true if the day is selected or highlighted
              return isSameDay(_selectedDate, day) || _highlightedDates.contains(day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _focusedDay = focusedDay; // Update focused day as well
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.red, // Highlight color
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Selected Date: $realTimeValue',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Check if today's date is selected before allowing check-in
              if (isSameDay(_selectedDate, DateTime.now())) {
                // Handle button press to highlight selected date
                setState(() {
                  // Toggle highlighting of selected date
                  if (_highlightedDates.contains(_selectedDate)) {
                    _highlightedDates.remove(_selectedDate);
                  } else {
                    _highlightedDates.add(_selectedDate);
                  }
                });
              } else {
                // Display a message or take appropriate action for invalid date
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Invalid Date'),
                      content: Text('You can only check in on today\'s date.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text('Check In'),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16), // Adjust margin as needed
            color: Colors.white, // Set background color to white
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Days clocked in: ${countHighlightedDays()}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Days absent: ${countNonHighlightedDays()}',
                      style: TextStyle(fontSize: 18),
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

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int countHighlightedDays() {
    DateTime startDate = DateTime.now().subtract(Duration(days: 30));
    DateTime endDate = DateTime.now().add(Duration(days: 30));

    int count = 0;
    for (DateTime date in _highlightedDates) {
      if (date.isAfter(startDate) && date.isBefore(endDate)) {
        count++;
      }
    }
    return count;
  }

  int countNonHighlightedDays() {
    DateTime firstDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    int count = -1;

    for (DateTime date = firstDayOfMonth; date.isBefore(DateTime.now()); date = date.add(Duration(days: 1))) {
      if (!_highlightedDates.contains(date)) {
        count++;
      }
    }
    return count;
  }
}
