import 'package:flutter/material.dart';

class Potato extends StatefulWidget {
  static const routeName = '/Potato';

  const Potato({super.key});

  @override
  _PotatoState createState() => _PotatoState();
}

class _PotatoState extends State<Potato> {
  String _searchQuery = '';

  final String description =
      "Potato (Solanum tuberosum) is a starchy tuber widely cultivated in Oman and worldwide. "
      "It is a versatile vegetable used in cooking, baking, and frying, with a mild flavor and firm texture.";

  final String careInstructions =
      "• Plant seed potatoes in well-drained soil with good organic content.\n"
      "• Space 30–40 cm apart in rows 75 cm apart.\n"
      "• Hilling soil around stems promotes tuber growth.\n"
      "• Fertilize with balanced nutrients; avoid excessive nitrogen to prevent excessive foliage.\n"
      "• Remove weeds regularly and monitor for pests.";

  final String idealEnvironment =
      "• Climate: Cool-season crop; tolerates mild frost.\n"
      "• Soil: Loose, well-drained loamy soil with pH 5.5–7.0.\n"
      "• Temperature: Ideal growth between 15°C and 20°C.\n"
      "• Light: Full sunlight, at least 6 hours daily.";

  final String wateringTips =
      "• Water consistently to keep soil moist but not waterlogged.\n"
      "• Frequency: 1–2 times per week; increase during dry periods.\n"
      "• Mulch to conserve moisture and control weeds.";

  final String sicknessInfo =
      "• Common Issues: Late blight, aphids, potato tuber moth, and scab.\n"
      "• Prevention: Crop rotation, certified seed potatoes, and proper spacing.\n"
      "• Treatment: Organic sprays or neem oil for pests; remove infected plants promptly.\n"
      "• Tip: Harvest when foliage yellows and soil is dry.";

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
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_full, color: Colors.brown),
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
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('Potato 🥔'),
        backgroundColor: Colors.brown,
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
                'assets/potato.jpg',
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
                backgroundColor: Colors.brown[700],
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  const FullScreenTextView({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.brown,
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
