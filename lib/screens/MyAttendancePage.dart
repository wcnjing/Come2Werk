import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(Duration(days: 30)); // Adjust as needed
    _lastDay = DateTime.now().add(Duration(days: 30)); // Adjust as needed
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
              'Selected Date: ${_selectedDate.toLocal()}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle button press to highlight selected date
              setState(() {
                // Toggle highlighting of selected date
                if (_highlightedDates.contains(_selectedDate)) {
                  _highlightedDates.remove(_selectedDate);
                } else {
                  _highlightedDates.add(_selectedDate);
                }
              });
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
                child: Text(
                  'Highlighted Days Count: ${countHighlightedDays()}',
                  style: TextStyle(fontSize: 18),
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
}



