import 'package:flutter/material.dart';

class WeekdayDropdownMenu extends StatefulWidget {
  final Function(int?) onSelected; // Callback to pass the selected value

  WeekdayDropdownMenu({required this.onSelected}); // Constructor with callback

  @override
  _WeekdayDropdownMenuState createState() => _WeekdayDropdownMenuState();
}

class _WeekdayDropdownMenuState extends State<WeekdayDropdownMenu> {
  final Map<String, int> weekdayMap = {
    'السبت': 1,
    'الأحد': 2,
    'الإثنين': 3,
    'الثلاثاء': 4,
    'الأربعاء': 5,
    'الخميس': 6,
    'الجمعة': 7,
  };

  int? selectedDayValue;

  Future<void> showWeekdayDropdown(BuildContext context) async {
    await showDialog<int?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اختر يومًا'),
          content: DropdownButton<int>(
            value: selectedDayValue,
            hint: Text('اختر يومًا'),
            items: weekdayMap.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.value,
                child: Text(entry.key),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                selectedDayValue = newValue; // Update selected day value
              });
              widget.onSelected(newValue); // Call the callback with the selected value
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showWeekdayDropdown(context), // Show the dropdown when tapped
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            selectedDayValue != null
                ? 'اليوم: ${weekdayMap.entries.firstWhere((e) => e.value == selectedDayValue).key}'
                : 'اختر يومًا',
          ),
        ),
      ),
    );
  }
}
