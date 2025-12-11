import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Tomato extends StatefulWidget {
  static const routeName = '/Tomato';

  const Tomato({super.key});

  @override
  _TomatoState createState() => _TomatoState();
}

class _TomatoState extends State<Tomato> {
  late FlutterTts tts;
  String _searchQuery = '';

  final String description =
      "Tomato (Solanum lycopersicum) is one of the most widely grown vegetables "
      "in Oman and worldwide. It is known for its juicy texture and rich flavor, "
      "used in salads, sauces, curries, and traditional dishes.";

  final String careInstructions =
      "• Plant seedlings in fertile, well-drained soil.\n"
      "• Provide support using stakes or cages.\n"
      "• Pinch off lower leaves to improve air circulation.\n"
      "• Use balanced fertilizer every 2–3 weeks.\n"
      "• Remove side shoots (suckers) to encourage stronger growth.";

  final String idealEnvironment =
      "• Climate: Warm climate with low humidity is ideal.\n"
      "• Soil: Rich loamy soil with pH 6.0–6.8.\n"
      "• Temperature: Best growth between 20°C and 30°C.\n"
      "• Light: Full sunlight for at least 6–8 hours daily.";

  final String wateringTips =
      "• Water deeply but infrequently.\n"
      "• Avoid overhead watering to prevent leaf diseases.\n"
      "• Water at the base of the plant.\n"
      "• Maintain consistent soil moisture during fruiting.";

  final String sicknessInfo =
      "• Common Issues: Blight, whiteflies, and blossom-end rot.\n"
      "• Prevention: Avoid wetting leaves; rotate crops yearly.\n"
      "• Treatment: Neem oil spray, organic pesticides, and calcium supplements.\n"
      "• Tip: Remove yellowing or diseased leaves early.";

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

  void _speak(String text) {
    tts.stop();
    tts.speak(text);
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.red),
                      onPressed: () => _speak(content),
                    ),
                    IconButton(
                      icon: const Icon(Icons.open_in_full, color: Colors.red),
                      onPressed: () => _openFullScreen(title, content),
                    ),
                  ],
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
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: const Text('Tomato 🍅'),
        backgroundColor: Colors.red,
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
                'assets/tomato1.jpg',
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

            // Back button
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
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
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.red,
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
