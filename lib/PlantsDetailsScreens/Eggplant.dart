import 'package:flutter/material.dart';

class Eggplant extends StatefulWidget {
  static const routeName = '/Eggplant';

  const Eggplant({super.key});

  @override
  _EggplantState createState() => _EggplantState();
}

class _EggplantState extends State<Eggplant> {
  String _searchQuery = '';

  final String description =
      "Eggplant (Solanum melongena), also known as aubergine or brinjal, "
      "is a widely cultivated vegetable in warm climates like Oman. "
      "Its glossy purple fruits are used in curries, stews, grills, "
      "and a variety of traditional dishes.";

  final String careInstructions =
      "• Plant seedlings in warm, fertile, well-drained soil.\n"
      "• Provide stakes or small supports for heavier varieties.\n"
      "• Remove yellowing leaves to improve airflow.\n"
      "• Apply balanced fertilizer every 2–3 weeks.\n"
      "• Mulch soil to keep roots cool and retain moisture.";

  final String idealEnvironment =
      "• Climate: Prefers hot, dry climates similar to Oman.\n"
      "• Soil: Loamy soil with pH 5.8–6.8.\n"
      "• Temperature: Optimal growth between 24°C and 32°C.\n"
      "• Light: Full sunlight for at least 6 hours a day.";

  final String wateringTips =
      "• Water deeply to encourage strong root growth.\n"
      "• Keep soil evenly moist but not soggy.\n"
      "• Avoid wetting the leaves to reduce fungal issues.\n"
      "• Increase watering during fruiting season.";

  final String sicknessInfo =
      "• Common Issues: Whiteflies, spider mites, flea beetles, and wilting diseases.\n"
      "• Prevention: Practice crop rotation and avoid overwatering.\n"
      "• Treatment: Neem oil, insecticidal soap, and proper spacing.\n"
      "• Tip: Remove severely affected leaves early.";

  void _openFullScreen(String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenTextView(title: title, content: content),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    if (_searchQuery.isNotEmpty &&
        !content.toLowerCase().contains(_searchQuery.toLowerCase()) &&
        !title.toLowerCase().contains(_searchQuery.toLowerCase())) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
                IconButton(
                  icon:
                  const Icon(Icons.open_in_full, color: Colors.deepPurple),
                  tooltip: 'View Fullscreen',
                  onPressed: () => _openFullScreen(title, content),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content.length > 150
                  ? "${content.substring(0, 150)}..."
                  : content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Eggplant 🍆'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText:
                'Search description, care, environment, watering, or sickness...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
            const SizedBox(height: 24),

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/eggplant.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: Text('Image not found')),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sections
            _buildSection('Description', description),
            _buildSection('Care Instructions', careInstructions),
            _buildSection('Ideal Environment', idealEnvironment),
            _buildSection('Watering Tips', wateringTips),
            _buildSection('Plant Sickness Information', sicknessInfo),

            const SizedBox(height: 24),

            // Back Button Only
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[700],
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Back',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ FULLSCREEN VIEW ------------------

class FullScreenTextView extends StatelessWidget {
  final String title;
  final String content;

  const FullScreenTextView(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 18, height: 1.6),
          ),
        ),
      ),
    );
  }
}
