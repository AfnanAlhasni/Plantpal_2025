import 'package:flutter/material.dart';

class Cabbage extends StatefulWidget {
  static const routeName = '/Cabbage';

  const Cabbage({super.key});

  @override
  _CabbageState createState() => _CabbageState();
}

class _CabbageState extends State<Cabbage> {
  String _searchQuery = '';

  final String description =
      "Cabbage (Brassica oleracea) is a leafy vegetable widely grown in many regions, "
      "including cooler seasons in Oman. It forms a tight round head of layered leaves and "
      "is commonly used in salads, soups, stews, and pickles.";

  final String careInstructions =
      "• Plant seedlings 40–50 cm apart for proper head formation.\n"
      "• Apply balanced fertilizer during early growth.\n"
      "• Mulch soil to retain moisture and reduce weeds.\n"
      "• Remove damaged lower leaves to encourage healthy growth.\n"
      "• Protect young plants from pests using organic sprays.";

  final String idealEnvironment =
      "• Climate: Prefers cooler months in Oman (October to February).\n"
      "• Soil: Rich, well-drained loamy soil with pH 6.0–7.5.\n"
      "• Temperature: Best growth at 15°C–24°C.\n"
      "• Light: Full sunlight (6–8 hours daily).";

  final String wateringTips =
      "• Keep soil consistently moist, especially during head formation.\n"
      "• Water 2–3 times weekly depending on season.\n"
      "• Avoid overhead watering to reduce fungal diseases.\n"
      "• Ensure proper drainage to prevent root rot.";

  final String sicknessInfo =
      "• Common Issues: Cabbage worms, aphids, black rot, and powdery mildew.\n"
      "• Prevention: Rotate crops yearly; avoid planting other brassicas nearby.\n"
      "• Treatment: Use neem oil or BT spray for worms.\n"
      "• Tip: Remove affected leaves and improve air circulation.";

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
        padding: const EdgeInsets.all(16),
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
                      color: Colors.green,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_full, color: Colors.green),
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
        title: const Text('Cabbage 🥬'),
        backgroundColor: Colors.green,
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
                'assets/cabbage1.jpg',
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

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Back',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// ---------------- FULLSCREEN VIEW ----------------

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
        backgroundColor: Colors.green,
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
