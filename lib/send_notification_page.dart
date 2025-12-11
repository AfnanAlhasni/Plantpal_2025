import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SendNotificationPage extends StatefulWidget {
  static const routeName = '/sendNotification';

  const SendNotificationPage({Key? key}) : super(key: key);

  @override
  _SendNotificationPageState createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isSending = false;

  final DatabaseReference _notificationsRef =
  FirebaseDatabase.instance.ref().child('notifications');

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    try {
      await _notificationsRef.push().set({
        'title': _titleController.text.trim(),
        'message': _messageController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Notification sent to all users!'),
          backgroundColor: Colors.green,
        ),
      );

      _titleController.clear();
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to send notification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Colors.black54,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Send Notification to All Users',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title Field
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Notification Title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title cannot be empty';
                          }
                          if (value.trim().length < 3) {
                            return 'Title must be at least 3 characters';
                          }
                          if (value.trim().length > 50) {
                            return 'Title cannot exceed 50 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Message Field
                      TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.message),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Message cannot be empty';
                          }
                          if (value.trim().length < 5) {
                            return 'Message must be at least 5 characters long';
                          }
                          if (value.trim().length > 300) {
                            return 'Message is too long (max 300 characters)';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSending ? null : _sendNotification,
                          icon: const Icon(Icons.send),
                          label: _isSending
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            'Send Notification',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
