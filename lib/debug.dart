import 'package:flutter/material.dart';

class TempTest extends StatefulWidget {
  @override
  State<TempTest> createState() => _TempTestState();
}

class _TempTestState extends State<TempTest> {
  DateTime dateTime = DateTime(2023, 12, 22, 12, 37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}: ${dateTime.minute}',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text(
                'select date & time',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: dateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100));
                if (newDate == null) return;

                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: dateTime.hour,
                    minute: dateTime.minute,
                  ),
                );
                if (newTime == null) return;
                final newDateTime = DateTime(
                  newDate.year,
                  newDate.month,
                  newDate.day,
                  newTime.hour,
                  newTime.minute,
                );
                setState(() {
                  dateTime = newDateTime;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}