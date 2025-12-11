import 'package:flutter/material.dart';

class Bougainvillea extends StatefulWidget {
  static const routeName = '/Bougainvillea';

  const Bougainvillea({super.key});

  @override
  _BougainvilleaState createState() => _BougainvilleaState();
}

class _BougainvilleaState extends State<Bougainvillea> {
  String _searchQuery = '';

  final String description =
      "Bougainvillea is a vibrant ornamental plant known for its colorful bracts, "
      "which come in shades of pink, purple, red, orange, and white. "
      "It is widely used in gardens, fences, and trellises, adding a splash of color.";

  final String careInstructions =
      "• Plant in well-drained soil.\n"
      "• Requires full sun for best flowering.\n"
      "• Prune regularly to maintain shape and encourage blooms.\n"
      "• Fertilize monthly with a balanced fertilizer.\n"
      "• Protect from frost; it is sensitive to cold temperatures.";

  final String idealEnvironment =
      "• Climate: Warm, tropical, or subtropical climates.\n"
      "• Soil: Well-drained, slightly acidic to neutral (pH 5.5–7.0).\n"
      "• Temperature: Thrives between 20°C and 35°C.\n"
      "• Light: Full sunlight, at least 6-8 hours daily.";

  final String wateringTips =
      "• Water moderately: Allow soil to dry between waterings.\n"
      "• Frequency: Once or twice a week, depending on temperature.\n"
      "• Container Growing: Ensure drainage holes to avoid waterlogging.";

  final String sicknessInfo =
      "• Common Issues: Aphids, caterpillars, root rot, and leaf spot.\n"
      "• Prevention: Avoid overwatering; keep plant well-pruned.\n"
      "• Treatment: Use neem oil or mild insecticidal soap.\n"
      "• Tip: Remove dead or infected leaves promptly to prevent spread.";

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
        title: const Text('Bougainvillea 🌸'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by description, care, environment, watering, or sickness...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                'assets/bougainvillea.jpg',
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
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
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
