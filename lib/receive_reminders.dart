import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({Key? key}) : super(key: key);

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child('reminders');

  List<Map<String, dynamic>> _reminders = [];

  @override
  void initState() {
    super.initState();
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final List<Map<String, dynamic>> remindersList = data.entries.map((e) {
        final value = Map<String, dynamic>.from(e.value as Map);
        return {
          'title': value['title'] ?? '',
          'message': value['message'] ?? '',
          'timestamp': value['timestamp'] != null
              ? DateTime.tryParse(value['timestamp'])
              : null,
        };
      }).toList();

      // Sort by upcoming reminders first
      remindersList.sort((a, b) {
        final t1 = a['timestamp'] as DateTime?;
        final t2 = b['timestamp'] as DateTime?;
        if (t1 == null) return 1;
        if (t2 == null) return -1;
        return t1.compareTo(t2);
      });

      setState(() {
        _reminders = remindersList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        backgroundColor: Colors.green[800],
      ),
      body: _reminders.isEmpty
          ? const Center(child: Text('No reminders found'))
          : ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          final timestamp = reminder['timestamp'] as DateTime?;
          final timeString = timestamp != null
              ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp)
              : 'No time set';

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.alarm, color: Colors.green),
              title: Text(reminder['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reminder['message']),
                  const SizedBox(height: 4),
                  Text(
                    'Scheduled: $timeString',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
