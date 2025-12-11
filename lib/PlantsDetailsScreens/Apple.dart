import 'package:flutter/material.dart';

class Apple extends StatefulWidget {
  static const routeName = '/Apple';

  const Apple({super.key});

  @override
  _AppleState createState() => _AppleState();
}

class _AppleState extends State<Apple> {
  String _searchQuery = '';

  final String description =
      "Apple (Malus domestica) is a deciduous fruit tree cultivated worldwide for its crisp, juicy fruits. "
      "It produces white to pink flowers in spring and requires temperate climates for optimal growth.";

  final String careInstructions =
      "• Plant in well-drained, fertile soil.\n"
      "• Requires full sun for at least 6–8 hours daily.\n"
      "• Fertilize in early spring with balanced fertilizer.\n"
      "• Prune annually to maintain shape and remove dead or diseased branches.\n"
      "• Protect young trees from pests and frost.";

  final String idealEnvironment =
      "• Climate: Temperate regions with cold winters.\n"
      "• Soil: Well-drained loamy soil, pH 6.0–7.0.\n"
      "• Temperature: Chilling hours needed for proper dormancy (0°C–7°C).\n"
      "• Light: Full sun exposure for healthy fruit production.";

  final String wateringTips =
      "• Water deeply once or twice a week during dry periods.\n"
      "• Mulch around the base to retain moisture and reduce weeds.\n"
      "• Reduce watering in dormant winter months.";

  final String sicknessInfo =
      "• Common Issues: Apple scab, powdery mildew, fire blight, aphids.\n"
      "• Prevention: Proper pruning, spacing, and sanitation.\n"
      "• Treatment: Use fungicides or insecticides as recommended.\n"
      "• Tip: Remove fallen leaves and infected branches to prevent disease spread.";

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
        title: const Text('Apple 🍎'),
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
                'assets/apple.jpg',
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
