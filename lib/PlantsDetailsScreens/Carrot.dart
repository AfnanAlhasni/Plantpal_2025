import 'package:flutter/material.dart';

class Carrot extends StatefulWidget {
  static const routeName = '/Carrot';

  const Carrot({super.key});

  @override
  _CarrotState createState() => _CarrotState();
}

class _CarrotState extends State<Carrot> {
  String _searchQuery = '';

  final String description =
      "Carrot (Daucus carota) is a root vegetable widely grown in Oman and globally. "
      "It is known for its sweet flavor, crunchy texture, and rich orange color, "
      "containing high levels of beta-carotene, fiber, and vitamins.";

  final String careInstructions =
      "• Sow seeds directly in loose, well-drained soil.\n"
      "• Thin seedlings to 5–10 cm apart.\n"
      "• Keep soil free of stones for proper root growth.\n"
      "• Use moderate fertilizer (avoid excess nitrogen).\n"
      "• Remove weeds regularly to reduce competition.";

  final String idealEnvironment =
      "• Climate: Prefers cool-season growth.\n"
      "• Soil: Sandy-loam, well-drained soil with pH 6.0–6.8.\n"
      "• Temperature: Ideal growth between 16°C and 21°C.\n"
      "• Light: Full sunlight for at least 6 hours daily.";

  final String wateringTips =
      "• Water evenly to maintain soil moisture.\n"
      "• Water 1–2 times per week depending on temperature.\n"
      "• Mulching helps retain soil moisture and control weeds.";

  final String sicknessInfo =
      "• Common Issues: Carrot fly, aphids, root rot, and powdery mildew.\n"
      "• Prevention: Crop rotation and proper spacing.\n"
      "• Treatment: Organic pesticides or neem oil.\n"
      "• Tip: Remove infected plants promptly to prevent spread.";

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
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + fullscreen icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_full, color: Colors.orange),
                  onPressed: () => _openFullScreen(title, content),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              content.length > 150 ? "${content.substring(0, 150)}..." : content,
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
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Carrot 🥕'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText:
                'Search description, care, environment, watering, or sickness...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                'assets/carrot1.jpg',
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

            _buildSection('Description', description),
            _buildSection('Care Instructions', careInstructions),
            _buildSection('Ideal Environment', idealEnvironment),
            _buildSection('Watering Tips', wateringTips),
            _buildSection('Plant Sickness Information', sicknessInfo),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 40),
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

// ---------------- FULLSCREEN VIEW ----------------

class FullScreenTextView extends StatelessWidget {
  final String title;
  final String content;

  const FullScreenTextView({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange,
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
