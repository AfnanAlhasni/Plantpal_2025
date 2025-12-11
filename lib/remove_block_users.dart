import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ManageUsersPage extends StatefulWidget {
  static const routeName = '/manageUsers';

  const ManageUsersPage({Key? key}) : super(key: key);

  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
  final DatabaseReference _logsRef =
  FirebaseDatabase.instance.ref('logs/users');

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  /// 🟩 Save user-related action to logs
  Future<void> _logUserAction(
      String action, String userName, String userEmail) async {
    final logData = {
      'action': action,
      'user': userName,
      'email': userEmail,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _logsRef.push().set(logData);
  }

  /// 🟢 Activate / Deactivate user
  void _toggleActivation(
      String uid, bool active, String name, String email) async {
    await _usersRef.child(uid).update({'active': active});

    final action = active ? 'Activated User' : 'Deactivated User';
    await _logUserAction(action, name, email);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          active ? 'User activated ✅' : 'User deactivated 🚫',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa8e063), Color(0xFF56ab2f)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // 🔎 Search bar
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search users by name or email...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 📌 User list
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _usersRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const Center(child: Text('No users found.'));
                  }

                  final data = Map<String, dynamic>.from(
                      snapshot.data!.snapshot.value as Map);
                  final users = data.entries.map((e) {
                    final userData = Map<String, dynamic>.from(e.value);
                    return {'uid': e.key, ...userData};
                  }).toList();

                  final filteredUsers = users.where((user) {
                    final name =
                    (user['fullName'] ?? '').toString().toLowerCase();
                    final email =
                    (user['email'] ?? '').toString().toLowerCase();
                    return name.contains(_searchQuery) ||
                        email.contains(_searchQuery);
                  }).toList();

                  if (filteredUsers.isEmpty) {
                    return const Center(
                        child: Text('No users match your search.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredUsers.length,
                    itemBuilder: (ctx, i) {
                      final user = filteredUsers[i];
                      final active = user['active'] == true;

                      final fullName = user['fullName'] ?? 'Unknown';
                      final email = user['email'] ?? 'N/A';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),

                          // Avatar
                          leading: CircleAvatar(
                            backgroundColor: active
                                ? Colors.green[400]
                                : Colors.red[400],
                            child: Icon(
                              active ? Icons.check : Icons.close,
                              color: Colors.white,
                            ),
                          ),

                          // Main title
                          title: Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Info
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email: $email'),
                              Text('Phone: ${user['phone'] ?? 'N/A'}'),
                              Text('Age: ${user['age'] ?? 'N/A'}'),
                              Text(
                                'Status: ${active ? 'Active ✔' : 'Inactive ✖'}',
                                style: TextStyle(
                                  color: active ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          // Menu
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'toggle') {
                                _toggleActivation(
                                    user['uid'], !active, fullName, email);
                              }
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: 'toggle',
                                child: Row(
                                  children: [
                                    Icon(
                                      active
                                          ? Icons.pause_circle
                                          : Icons.play_circle,
                                      color:
                                      active ? Colors.red : Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(active
                                        ? 'Deactivate'
                                        : 'Activate'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
