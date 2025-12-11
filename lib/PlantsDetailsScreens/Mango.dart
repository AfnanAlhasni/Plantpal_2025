import 'package:flutter/material.dart';

class Mango extends StatefulWidget {
  static const routeName = '/Mango';

  const Mango({super.key});

  @override
  _MangoState createState() => _MangoState();
}

class _MangoState extends State<Mango> {
  String _searchQuery = '';

  final String description =
      "Mango Tree (Mangifera indica) is a tropical fruit tree known for its sweet, juicy fruits. "
      "It is widely cultivated in Oman and other tropical regions and is appreciated both for its fruit and shade.";

  final String careInstructions =
      "• Plant in well-drained soil with plenty of sunlight.\n"
      "• Water young trees regularly; reduce watering as they mature.\n"
      "• Prune to maintain shape and remove dead branches.\n"
      "• Fertilize with balanced fertilizer during growth season.\n"
      "• Mulch around the base to retain moisture and reduce weeds.";

  final String idealEnvironment =
      "• Climate: Tropical and subtropical; prefers warm weather.\n"
      "• Soil: Sandy loam, rich in organic matter, well-drained.\n"
      "• Temperature: 24°C to 30°C is ideal.\n"
      "• Light: Full sunlight, at least 6–8 hours daily.";

  final String wateringTips =
      "• Young trees: Water 2–3 times per week.\n"
      "• Mature trees: Deep watering every 2 weeks.\n"
      "• Ensure soil is moist but not waterlogged.\n"
      "• Use drip irrigation for best results.";

  final String sicknessInfo =
      "• Common Issues: Anthracnose, powdery mildew, mango weevil.\n"
      "• Prevention: Ensure good air circulation; avoid wetting foliage.\n"
      "• Treatment: Fungicide sprays for fungal issues; remove infected fruits/leaves.\n"
      "• Tip: Regular inspection of fruits and leaves can prevent major losses.";

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
                      color: Colors.orange),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_full, color: Colors.orange),
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
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Mango Tree 🥭'),
        backgroundColor: const Color(0xFFF57C00),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                'assets/mango.jpg',
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
                backgroundColor: Colors.orange,
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
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

  const FullScreenTextView(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFF57C00),
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
