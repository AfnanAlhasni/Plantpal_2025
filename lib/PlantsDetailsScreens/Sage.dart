import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Sage extends StatefulWidget {
  static const routeName = '/Sage';

  const Sage({super.key});

  @override
  _SageState createState() => _SageState();
}

class _SageState extends State<Sage> {
  late FlutterTts tts;
  
  String _searchQuery = '';

  final String description =
      "Sage (Salvia officinalis) is an aromatic herb with soft gray-green leaves. "
      "It is known for its earthy flavor and is often used in teas, meats, "
      "and traditional remedies. Sage is hardy, drought-tolerant, and well-suited "
      "to Oman’s warm climate.";

  final String careInstructions =
      "• Plant sage in well-drained soil and full sun.\n"
      "• Prune lightly to encourage bushy growth.\n"
      "• Avoid overwatering to prevent root problems.\n"
      "• Fertilize sparingly—too much fertilizer reduces flavor.\n"
      "• Remove woody stems annually to maintain plant health.";

  final String idealEnvironment =
      "• Climate: Thrives in warm, dry conditions similar to Oman.\n"
      "• Soil: Sandy or loamy soil with excellent drainage, pH 6.0–7.5.\n"
      "• Temperature: Best growth occurs between 20°C–35°C.\n"
      "• Light: Needs full sun (6+ hours daily) to develop strong aroma.";

  final String wateringTips =
      "• Water deeply but infrequently.\n"
      "• Allow soil to dry between watering sessions.\n"
      "• Water once or twice weekly depending on heat.\n"
      "• Avoid wetting the leaves to reduce fungal issues.";

  final String sicknessInfo =
      "• Common Issues: Root rot, powdery mildew, and spider mites.\n"
      "• Prevention: Ensure dry conditions and good airflow.\n"
      "• Treatment: Apply neem oil for pests and fungal infections.\n"
      "• Tip: Remove overcrowded stems to improve air circulation.";

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
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
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Sage 🌿'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText:
                'Search by description, care, environment, watering, or sickness...',
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

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/sage.png',
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

  const FullScreenTextView({
    super.key,
    required this.title,
    required this.content,
  });

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
        padding: const EdgeInsets.all(24),
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
