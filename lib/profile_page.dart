import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'services.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref().child('users/$uid');

    return StreamBuilder<DatabaseEvent>(
      stream: ref.onValue,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }

        final raw = snap.data?.snapshot.value;
        final data = (raw is Map) ? Map<dynamic, dynamic>.from(raw) : <dynamic, dynamic>{};

        final fullName = (data['fullName'] ?? '') as String;
        final email = (data['email'] ?? '') as String;
        final phone = (data['phone'] ?? '') as String;
        final age = int.tryParse('${data['age'] ?? ''}') ?? 0;

        Widget infoCard(IconData icon, String label, String value) {
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.green.shade50,
            child: ListTile(
              leading: Icon(icon, color: Colors.green.shade700),
              title: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                value.isEmpty ? 'Not specified' : value,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade100, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      infoCard(Icons.person, 'Full Name', fullName),
                      infoCard(Icons.email, 'Email', email),
                      infoCard(Icons.phone, 'Phone', phone),
                      infoCard(Icons.cake, 'Age', age == 0 ? '' : '$age'),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.green.shade700,
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfilePage(
                                  currentName: fullName,
                                  currentEmail: email,
                                  currentPhone: phone,
                                  currentAge: age,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
