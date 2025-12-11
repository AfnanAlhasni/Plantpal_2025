import 'package:flutter/material.dart';
import 'package:plantpal_2025/comments_page.dart';
import 'package:plantpal_2025/remove_block_users.dart';
import 'package:plantpal_2025/send_notification_page.dart';
import 'package:plantpal_2025/send_reminder_page.dart';
import 'package:plantpal_2025/update_delete_page.dart';
import 'package:plantpal_2025/view_activity_logs.dart';
import 'package:plantpal_2025/view_all_users.dart';
import 'package:plantpal_2025/view_notification_history.dart';
import 'plants_page.dart';
import 'add_plant_page.dart';
import 'admin_login_page.dart';

class AdminPage extends StatelessWidget {
  static const String routeName = '/admin';

  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green[800],
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacementNamed(context, AdminLoginPage.routeName);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa8e063), Color(0xFF56ab2f)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 120,
                  color: Colors.white,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Admin Control Center',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // 🌿 PLANTS MANAGEMENT
                _buildDropdownSection(
                  context,
                  title: 'Manage Plants',
                  icon: Icons.local_florist,
                  color: Colors.green[800]!,
                  items: [
                    _DropdownItem(
                      title: 'View All Plants',
                      icon: Icons.list_alt,
                      onTap: () =>
                          Navigator.pushNamed(context, PlantsPage.routeName),
                    ),
                    _DropdownItem(
                      title: 'Add New Plant',
                      icon: Icons.add_circle_outline,
                      onTap: () =>
                          Navigator.pushNamed(context, AddPlantPage.routeName),
                    ),
                    _DropdownItem(
                      title: 'Update / Delete Plants',
                      icon: Icons.edit,
                      onTap: () => Navigator.pushNamed(
                          context, UpdateDeletePage.routeName),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 👥 USER MANAGEMENT
                _buildDropdownSection(
                  context,
                  title: 'Manage Users',
                  icon: Icons.people_alt,
                  color: Colors.teal[800]!,
                  items: [
                    _DropdownItem(
                      title: 'View All Users',
                      icon: Icons.person_search,
                      onTap: () =>
                          Navigator.pushNamed(context, ViewAllUsersPage.routeName),
                    ),
                    _DropdownItem(
                      title: 'Activate or Deactivate User',
                      icon: Icons.block,
                      onTap: () =>
                          Navigator.pushNamed(context, ManageUsersPage.routeName),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔔 NOTIFICATIONS
                _buildDropdownSection(
                  context,
                  title: 'Notifications',
                  icon: Icons.notifications_active,
                  color: Colors.orange[800]!,
                  items: [
                    _DropdownItem(
                      title: 'Send Notification to All Users',
                      icon: Icons.send,
                      onTap: () => Navigator.pushNamed(
                          context, SendNotificationPage.routeName),
                    ),
                    _DropdownItem(
                      title: 'View Notification History',
                      icon: Icons.history,
                      onTap: () => Navigator.pushNamed(
                          context, ViewNotificationHistoryPage.routeName),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ⚙️ SYSTEM / REPORTS / FEEDBACK
                _buildDropdownSection(
                  context,
                  title: 'System & Reports',
                  icon: Icons.settings,
                  color: Colors.blueGrey[800]!,
                  items: [
                    _DropdownItem(
                      title: 'View Activity Logs',
                      icon: Icons.assignment,
                      onTap: () => Navigator.pushNamed(
                          context, ViewActivityLogsPage.routeName),
                    ),
                    _DropdownItem(
                      title: 'View Feedback', // ✅ Kept feedback
                      icon: Icons.feedback,
                      onTap: () => Navigator.pushNamed(
                          context, CommentsPage.routeName),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDropdownSection(
                  context,
                  title: 'Reminders',
                  icon: Icons.alarm,
                  color: Colors.purple[800]!,
                  items: [
                    _DropdownItem(
                      title: 'Send Reminder',
                      icon: Icons.send,
                      onTap: () =>
                          Navigator.pushNamed(context, SendReminderPage.routeName),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for dropdown sections
  Widget _buildDropdownSection(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required List<_DropdownItem> items,
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
        childrenPadding:
        const EdgeInsets.only(left: 20, right: 16, bottom: 10),
        children: items
            .map(
              (item) => ListTile(
            leading: Icon(item.icon, color: color),
            title: Text(
              item.title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: item.onTap,
          ),
        )
            .toList(),
      ),
    );
  }
}

class _DropdownItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _DropdownItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
