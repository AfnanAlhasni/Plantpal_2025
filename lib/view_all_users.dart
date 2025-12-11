import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewAllUsersPage extends StatefulWidget {
  static const routeName = '/viewAllUsers';

  const ViewAllUsersPage({Key? key}) : super(key: key);

  @override
  _ViewAllUsersPageState createState() => _ViewAllUsersPageState();
}

class _ViewAllUsersPageState extends State<ViewAllUsersPage> {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildUserCard(Map user) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[700],
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          user['fullName'] ?? 'Unknown User',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email: ${user['email'] ?? 'N/A'}"),
              Text("Phone: ${user['phone'] ?? 'N/A'}"),
              Text("Age: ${user['age']?.toString() ?? 'N/A'}"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Registered Users 👥'),
        backgroundColor: Colors.green[700],
        elevation: 0,
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
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search users by name, email, or phone...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _usersRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red)));
                  }

                  final data = (snapshot.data! as DatabaseEvent).snapshot.value;
                  if (data == null) {
                    return const Center(
                        child: Text('No users found 😕',
                            style: TextStyle(fontSize: 16)));
                  }

                  final usersMap = Map<String, dynamic>.from(data as Map);
                  final usersList = usersMap.values
                      .map((e) => Map<String, dynamic>.from(e))
                      .where((user) =>
                  (user['fullName'] ?? '')
                      .toLowerCase()
                      .contains(_searchQuery) ||
                      (user['email'] ?? '')
                          .toLowerCase()
                          .contains(_searchQuery) ||
                      (user['phone'] ?? '')
                          .toLowerCase()
                          .contains(_searchQuery))
                      .toList();

                  if (usersList.isEmpty) {
                    return const Center(
                        child: Text('No matching users found 🌱'));
                  }

                  return ListView.builder(
                    itemCount: usersList.length,
                    itemBuilder: (context, index) {
                      final user = usersList[index];
                      return _buildUserCard(user);
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
