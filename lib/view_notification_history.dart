import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ViewNotificationHistoryPage extends StatefulWidget {
  static const routeName = '/viewNotificationHistory';

  const ViewNotificationHistoryPage({Key? key}) : super(key: key);

  @override
  _ViewNotificationHistoryPageState createState() =>
      _ViewNotificationHistoryPageState();
}

class _ViewNotificationHistoryPageState
    extends State<ViewNotificationHistoryPage> {
  final DatabaseReference _notificationsRef =
  FirebaseDatabase.instance.ref().child('notifications');

  List<Map<dynamic, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    _notificationsRef.onValue.listen((event) {
      final data = event.snapshot.value;
      final List<Map<dynamic, dynamic>> loaded = [];

      if (data != null && data is Map<dynamic, dynamic>) {
        data.forEach((key, value) {
          if (value is Map) {
            loaded.add({
              'key': key,
              'title': value['title'] ?? 'No Title',
              'message': value['message'] ?? 'No Message',
              'timestamp': value['timestamp'] ?? '',
            });
          }
        });
        loaded.sort((a, b) => (b['timestamp'] ?? '')
            .toString()
            .compareTo((a['timestamp'] ?? '').toString()));
      }

      setState(() {
        _notifications = loaded;
        _isLoading = false;
      });
    });
  }

  String _formatDate(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> _confirmDelete(String key) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content:
        const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _deleteNotification(key);
    }
  }

  Future<void> _deleteNotification(String key) async {
    try {
      await _notificationsRef.child(key).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmClearAll() async {
    if (_notifications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No notifications to delete')),
      );
      return;
    }

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
            'Are you sure you want to delete ALL notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _clearAllNotifications();
    }
  }

  Future<void> _clearAllNotifications() async {
    try {
      await _notificationsRef.remove();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All notifications deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete all: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification History'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear All Notifications',
            onPressed: _confirmClearAll,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _notifications.isEmpty
            ? const Center(
          child: Text(
            'No notifications sent yet.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              shadowColor: Colors.black54,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.notifications_active,
                    color: Colors.green, size: 36),
                title: Text(
                  notification['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(notification['timestamp']),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _confirmDelete(notification['key']),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
