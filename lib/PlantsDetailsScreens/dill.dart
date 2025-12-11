import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Dill extends StatefulWidget {
  static const routeName = '/Dill';

  const Dill({super.key});

  @override
  _DillState createState() => _DillState();
}

class _DillState extends State<Dill> {
  late FlutterTts tts;
  String _searchQuery = '';

  final String description =
      "Dill (Anethum graveolens) is an aromatic herb widely used in Omani cuisine, "
      "especially in soups, stews, and fish dishes. It has delicate feathery leaves "
      "with a fresh, slightly tangy flavor.";

  final String careInstructions =
      "• Sow seeds directly into well-drained soil.\n"
      "• Dill prefers full sun exposure.\n"
      "• Thin seedlings to 15-20 cm spacing.\n"
      "• Regularly remove flowers to extend leaf production.\n"
      "• Fertilize lightly; avoid excess nitrogen to maintain flavor.";

  final String idealEnvironment =
      "• Climate: Warm and sunny, typical of Oman’s coastal and inland regions.\n"
      "• Soil: Well-drained, loamy soil with pH 5.5–7.0.\n"
      "• Temperature: Ideal growth between 18°C and 30°C.\n"
      "• Light: Full sunlight, at least 6 hours per day.";

  final String wateringTips =
      "• Water moderately: Keep soil evenly moist but not waterlogged.\n"
      "• Frequency: Twice a week in hot seasons; reduce in cooler months.\n"
      "• Container Growing: Ensure good drainage to prevent root rot.";

  final String sicknessInfo =
      "• Common Issues: Aphids, powdery mildew, and leaf spots.\n"
      "• Prevention: Avoid overcrowding plants; ensure good air circulation.\n"
      "• Treatment: Spray neem oil or mild insecticidal soap weekly.\n"
      "• Tip: Remove infected leaves early to stop spread.";

  @override
  void initState() {
    super.initState();
    tts = FlutterTts();
    tts.setLanguage("en-US");
    tts.setSpeechRate(0.5);
    tts.setPitch(1.0);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  void _speakText() {
    final textToRead =
        "$description\n\nCare Instructions:\n$careInstructions\n\n"
        "Ideal Environment:\n$idealEnvironment\n\nWatering Tips:\n$wateringTips\n\n"
        "Plant Sickness Information:\n$sicknessInfo";
    tts.speak(textToRead);
  }

  void _openFullScreen(String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenTextView(title: title, content: content),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    // Search filter
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
            // Header Row with Expand Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_full, color: Colors.green),
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
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Dill 🌿'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Search Field
            TextField(
              decoration: InputDecoration(
                hintText:
                'Search by description, care, environment, watering, or sickness...',
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
                'assets/dill.jpg',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _speakText,
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Read Aloud'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
          ],
        ),
      ),
    );
  }
}

/// ------------------ FULLSCREEN TEXT VIEW ------------------

class FullScreenTextView extends StatelessWidget {
  final String title;
  final String content;

  const FullScreenTextView({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF2E7D32),
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
