import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart'; // Add this to pubspec.yaml

class ViewActivityLogsPage extends StatefulWidget {
  static const String routeName = '/viewActivityLogs';

  const ViewActivityLogsPage({Key? key}) : super(key: key);

  @override
  State<ViewActivityLogsPage> createState() => _ViewActivityLogsPageState();
}

class _ViewActivityLogsPageState extends State<ViewActivityLogsPage> {
  final DatabaseReference _userLogsRef =
  FirebaseDatabase.instance.ref('logs/users');

  Future<void> _downloadPDF(String title, List<Map<String, dynamic>> logs) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text(
              title,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          ...logs.map(
                (log) => pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 5),
              child: pw.Text(
                "• ${log['action']} - ${log['user'] ?? 'N/A'} (${log['email'] ?? 'N/A'})\n   Time: ${log['timestamp']}",
                style: const pw.TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: '$title.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Logs'),
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.assignment, size: 100, color: Colors.white),
              const SizedBox(height: 10),
              const Text(
                'System Activity Logs',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // 🧑‍💻 USER LOGS
              _buildFirebaseLogSection(
                title: 'User Logs',
                icon: Icons.people_alt,
                color: Colors.teal[800]!,
                reference: _userLogsRef,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirebaseLogSection({
    required String title,
    required IconData icon,
    required Color color,
    required DatabaseReference reference,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: Colors.black45,
      color: Colors.white.withOpacity(0.95),
      child: ExpansionTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        childrenPadding: const EdgeInsets.only(left: 20, right: 16, bottom: 10),
        children: [
          StreamBuilder<DatabaseEvent>(
            stream: reference.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('No logs available.'),
                );
              }

              final data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
              final logs = data.entries.map((e) {
                final log = Map<String, dynamic>.from(e.value);
                return log;
              }).toList();

              logs.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

              return Column(
                children: [
                  ...logs.map(
                        (log) => ListTile(
                      leading: const Icon(Icons.arrow_right, color: Colors.black54),
                      title: Text(
                        log['action'] ?? 'No action',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${log['user'] ?? 'Unknown'} (${log['email'] ?? 'N/A'})\n${log['timestamp'] ?? ''}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12, bottom: 8),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.download),
                        label: const Text('Download PDF'),
                        onPressed: () => _downloadPDF(title, logs),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
