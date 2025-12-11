import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DatePalm extends StatefulWidget {
  static const routeName = '/DatePalm';

  const DatePalm({super.key});

  @override
  _DatePalmState createState() => _DatePalmState();
}

class _DatePalmState extends State<DatePalm> {
  late FlutterTts tts;
  String _searchQuery = '';

  final String description =
      "Date palm (Phoenix dactylifera) is a tall, iconic tree widely cultivated in Oman "
      "and other Middle Eastern countries for its sweet, nutritious dates. It has a long, "
      "slender trunk and feathery pinnate leaves, making it both ornamental and productive.";

  final String careInstructions =
      "• Plant in full sun for best growth.\n"
      "• Date palms require deep, well-drained soil.\n"
      "• Fertilize with a balanced palm fertilizer 2-3 times a year.\n"
      "• Remove dead fronds regularly.\n"
      "• Protect young palms from strong winds and pests.";

  final String idealEnvironment =
      "• Climate: Hot, arid, or semi-arid regions.\n"
      "• Soil: Sandy loam or well-drained soils with pH 7.0–8.0.\n"
      "• Temperature: Thrives in 25°C to 45°C.\n"
      "• Light: Full sunlight, minimum 8 hours per day.";

  final String wateringTips =
      "• Water deeply and infrequently; allow soil to dry between waterings.\n"
      "• Young palms need frequent watering; mature palms are drought tolerant.\n"
      "• Drip irrigation is ideal for consistent moisture.";

  final String sicknessInfo =
      "• Common Issues: Red palm weevil, spider mites, Fusarium wilt.\n"
      "• Prevention: Regular inspection and proper sanitation.\n"
      "• Treatment: Apply recommended insecticides or fungicides.\n"
      "• Tip: Remove affected leaves early to prevent disease spread.";

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
            // ---------- TITLE + ICONS ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),

                // Fullscreen icon
                IconButton(
                  icon: const Icon(Icons.open_in_full, color: Colors.green),
                  onPressed: () => _openFullScreen(title, content),
                ),

                // Text-to-speech icon
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.green),
                  onPressed: () => _speak(content),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ---------- PREVIEW TEXT ----------
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
        title: const Text('Date Palm 🌴'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // SEARCH BAR
            TextField(
              decoration: InputDecoration(
                hintText:
                'Search description, care, environment, watering, sickness...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.trim());
              },
            ),

            const SizedBox(height: 24),

            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/date-palm.jpg',
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

            // BACK BUTTON
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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
