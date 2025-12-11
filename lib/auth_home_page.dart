import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantpal_2025/receive_reminders.dart';
import 'services.dart';
import 'plants_overview_page.dart';
import 'profile_page.dart';
import 'feedback_page.dart';
import 'chatbot_page.dart';
import 'share_plant_page.dart';


class AuthHomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _AuthHomePageState createState() => _AuthHomePageState();
}

class _AuthHomePageState extends State<AuthHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  double _darkIntensity = 0; // 0 = light, 1 = full dark
  late final List<Widget> _pages;
  late final List<String> _pageTitles;

  @override
  void initState() {
    super.initState();
    _pages = [
      const PlantsOverviewPage(),
      const ChatBotPage(),
      ProfilePage(),
      FeedbackPage(),
      const SharePlantPage(),
      const RemindersPage(), // <-- new page
    ];

    _pageTitles = [
      'Plants',
      'Chat',
      'Profile',
      'Feedback',
      'Share Plant',
      'Reminders'
    ];
  }

  Future<bool> _onWillPop() async {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
      return false;
    }
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    }
    return true;
  }

  Color get backgroundColor =>
      Color.lerp(Colors.grey[100], Colors.grey[900], _darkIntensity)!;
  Color get appBarColor =>
      Color.lerp(Colors.white, Colors.grey[850], _darkIntensity)!;
  Color get textColor =>
      Color.lerp(Colors.black, Colors.white, _darkIntensity)!;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 2,
          title: Text(
            _pageTitles[_currentIndex],
            style: TextStyle(color: textColor),
          ),
          leading: IconButton(
            icon: Icon(Icons.menu, color: textColor),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
              Navigator.of(context).pop();
            }
          },
          child: user == null
              ? const Center(child: Text('Please sign in first.'))
              : _pages[_currentIndex],
        ),
        drawer: _FancyDrawer(
          isDark: _darkIntensity > 0.5,
          currentIndex: _currentIndex,
          onSelect: (i) {
            setState(() => _currentIndex = i);
            Navigator.of(context).pop();
          },
          darkIntensity: _darkIntensity,
          onDarkIntensityChanged: (v) => setState(() => _darkIntensity = v),
          onSignOut: () async {
            await AuthService().signOut();
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/signIn');
            }
          },
        ),
      ),
    );
  }
}

class _FancyDrawer extends StatelessWidget {
  final bool isDark;
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final double darkIntensity;
  final ValueChanged<double> onDarkIntensityChanged;
  final VoidCallback onSignOut;

  const _FancyDrawer({
    Key? key,
    required this.isDark,
    required this.currentIndex,
    required this.onSelect,
    required this.darkIntensity,
    required this.onDarkIntensityChanged,
    required this.onSignOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey[850]!, Colors.grey[900]!]
                : [Colors.green.shade300, Colors.green.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              _FancyMenuTile(
                  icon: Icons.home,
                  title: 'Plants',
                  color: Colors.orange,
                  selected: currentIndex == 0,
                  onTap: () => onSelect(0)),
              _FancyMenuTile(
                  icon: Icons.chat_bubble,
                  title: 'Chat',
                  color: Colors.blue,
                  selected: currentIndex == 1,
                  onTap: () => onSelect(1)),
              _FancyMenuTile(
                  icon: Icons.person,
                  title: 'Profile',
                  color: Colors.purple,
                  selected: currentIndex == 2,
                  onTap: () => onSelect(2)),
              _FancyMenuTile(
                  icon: Icons.feedback,
                  title: 'Feedback',
                  color: Colors.red,
                  selected: currentIndex == 3,
                  onTap: () => onSelect(3)),
              _FancyMenuTile(
                  icon: Icons.upload,
                  title: 'Share',
                  color: Colors.white,
                  selected: currentIndex == 4,
                  onTap: () => onSelect(4)),
              _FancyMenuTile(
                  icon: Icons.notifications,
                  title: 'Reminders',
                  color: Colors.yellow,
                  selected: currentIndex == 5,
                  onTap: () => onSelect(5)),
              const Divider(color: Colors.white70),
              ListTile(
                leading: const Icon(Icons.brightness_6, color: Colors.white),
                title:
                const Text('Dark Intensity', style: TextStyle(color: Colors.white)),
                subtitle: Slider(
                  value: darkIntensity,
                  onChanged: onDarkIntensityChanged,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: '${(darkIntensity * 100).round()}%',
                  activeColor: Colors.white,
                  inactiveColor: Colors.white54,
                ),
              ),
              const Divider(color: Colors.white70),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
                onTap: onSignOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FancyMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _FancyMenuTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: selected
          ? BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      )
          : null,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        onTap: onTap,
      ),
    );
  }
}
