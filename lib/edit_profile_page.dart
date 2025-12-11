import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhone;
  final int currentAge;

  const EditProfilePage({
    Key? key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
    required this.currentAge,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _phone;
  late int _age;

  @override
  void initState() {
    super.initState();
    _name = widget.currentName;
    _email = widget.currentEmail;
    _phone = widget.currentPhone;
    _age = widget.currentAge;
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref().child('users/$uid');
    await ref.update({
      'fullName': _name,
      'email': _email,
      'phone': _phone,
      'age': _age,
    });
    Navigator.pop(context);
  }

  Widget _buildInfoCard(String label, String initialValue, IconData icon,
      Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.green.shade700),
            border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInfoCard('Name', _name, Icons.person, (val) => _name = val),
              _buildInfoCard(
                  'Email', _email, Icons.email, (val) => _email = val,
                  keyboardType: TextInputType.emailAddress),
              _buildInfoCard('Phone', _phone, Icons.phone, (val) => _phone = val,
                  keyboardType: TextInputType.phone),
              _buildInfoCard('Age', _age == 0 ? '' : '$_age', Icons.cake,
                      (val) => _age = int.tryParse(val) ?? 0,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      backgroundColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    onPressed: _saveProfile,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
