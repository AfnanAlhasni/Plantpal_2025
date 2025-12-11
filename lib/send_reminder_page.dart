import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:plantpal_2025/reminder_service.dart';

class SendReminderPage extends StatefulWidget {
  static const routeName = '/sendReminder';
  const SendReminderPage({Key? key}) : super(key: key);

  @override
  State<SendReminderPage> createState() => _SendReminderPageState();
}

class _SendReminderPageState extends State<SendReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  DateTime? _scheduledDateTime;
  bool _sending = false;

  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child('reminders');

  @override
  void initState() {
    super.initState();
    NotificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Reminder'),
        backgroundColor: Colors.green[800],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Reminder Title',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter a title';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Message
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    prefixIcon: const Icon(Icons.message),
                    counterText: '${_messageController.text.length}/200',
                  ),
                  maxLines: 4,
                  maxLength: 200,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter a message';
                    if (value.length > 200) return 'Message too long';
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),

                // Date & Time Picker
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    _scheduledDateTime == null
                        ? 'Pick Reminder Time'
                        : DateFormat('yyyy-MM-dd HH:mm')
                        .format(_scheduledDateTime!),
                  ),
                  onTap: _pickDateTime,
                ),
                const SizedBox(height: 30),

                // Send button
                ElevatedButton(
                  onPressed: _sending ? null : _sendReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _sending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Send Reminder',
                      style: TextStyle(fontSize: 18)),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// PICK DATE & TIME
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _scheduledDateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  /// SEND REMINDER
  void _sendReminder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_scheduledDateTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pick a date & time')));
      return;
    }

    setState(() => _sending = true);

    final newRef = _dbRef.push();

    await newRef.set({
      'title': _titleController.text.trim(),
      'message': _messageController.text.trim(),
      'timestamp': _scheduledDateTime!.toIso8601String(),
    });

    await NotificationService.scheduleNotification(
      id: newRef.key.hashCode,
      title: _titleController.text.trim(),
      body: _messageController.text.trim(),
      scheduledDate: _scheduledDateTime!,
    );

    setState(() => _sending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder scheduled successfully!')),
    );

    _titleController.clear();
    _messageController.clear();
    setState(() => _scheduledDateTime = null);
  }
}
