import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DesertRose extends StatefulWidget {
  static const routeName = '/DesertRoseInfo';

  const DesertRose({super.key});

  @override
  _DesertRoseState createState() => _DesertRoseState();
}

class _DesertRoseState extends State<DesertRose> {
  late FlutterTts tts;
  String _searchQuery = '';

  final String description =
      "Desert Rose (Adenium obesum) is a striking succulent plant known for its thick, swollen stem "
      "and beautiful trumpet-shaped flowers. Popular in Oman as an ornamental plant, it thrives in arid conditions.";

  final String careInstructions =
      "• Plant in well-draining sandy or loamy soil.\n"
      "• Place in full sun to encourage flowering.\n"
      "• Avoid overwatering; allow soil to dry between waterings.\n"
      "• Fertilize monthly during growing season with balanced succulent fertilizer.\n"
      "• Prune occasionally to shape and encourage new blooms.";

  final String idealEnvironment =
      "• Climate: Hot and dry, desert-like regions.\n"
      "• Soil: Well-drained, slightly acidic to neutral (pH 6–7).\n"
      "• Temperature: Thrives in 20°C to 35°C.\n"
      "• Light: Full sunlight, at least 6–8 hours per day.";

  final String wateringTips =
      "• Water sparingly: Only when the soil is completely dry.\n"
      "• Container Growing: Use pots with drainage holes to prevent root rot.\n"
      "• Winter: Reduce watering significantly during dormant period.";

  final String sicknessInfo =
      "• Common Issues: Root rot, aphids, mealybugs.\n"
      "• Prevention: Ensure proper drainage and avoid overwatering.\n"
      "• Treatment: Use insecticidal soap for pests; remove affected roots or leaves for diseases.\n"
      "• Tip: Desert Rose is toxic if ingested, handle with care.\n"
      "⚠️ Toxic if ingested! Keep away from children and pets.";

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
        title: const Text('Desert Rose 🌵'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/desert-rose.jpg',
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

  const FullScreenTextView(
      {super.key, required this.title, required this.content});

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
