import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsPage extends StatefulWidget {
  static const routeName = '/appSettings';

  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    });
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _darkMode);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setDouble('fontSize', _fontSize);
  }

  // Apply dark/light theme instantly
  ThemeData _buildTheme() {
    return _darkMode
        ? ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(primary: Colors.green),
    )
        : ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(primary: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Settings'),
          backgroundColor: Colors.green[700],
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable or disable dark mode'),
              value: _darkMode,
              onChanged: (val) {
                setState(() => _darkMode = val);
                _saveSettings();
              },
              activeColor: Colors.green[700],
            ),
            const Divider(),

            SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Enable or disable notifications'),
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
                _saveSettings();
              },
              activeColor: Colors.green[700],
            ),
            const Divider(),

            ListTile(
              title: const Text('Font Size'),
              subtitle: Text(
                'Adjust font size: ${_fontSize.toStringAsFixed(0)}',
              ),
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  value: _fontSize,
                  min: 12,
                  max: 24,
                  divisions: 6,
                  activeColor: Colors.green[700],
                  label: _fontSize.toStringAsFixed(0),
                  onChanged: (val) {
                    setState(() => _fontSize = val);
                    _saveSettings();
                  },
                ),
              ),
            ),
            const Divider(),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Save and Apply'),
                onPressed: () {
                  _saveSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved successfully ✅'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
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
