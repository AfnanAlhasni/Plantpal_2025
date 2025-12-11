import 'package:flutter/material.dart';

class Garlic extends StatefulWidget {
  static const routeName = '/Garlic';

  const Garlic({super.key});

  @override
  _GarlicState createState() => _GarlicState();
}

class _GarlicState extends State<Garlic> {
  String _searchQuery = '';

  final String description =
      "Garlic (Allium sativum) is a bulbous plant widely cultivated for its aromatic cloves, "
      "used extensively in cooking, traditional medicine, and as a natural pest repellent. "
      "It has long green leaves and produces small white flowers.";

  final String careInstructions =
      "• Plant cloves in well-drained, fertile soil.\n"
      "• Requires full sun exposure.\n"
      "• Space cloves 10–15 cm apart for healthy growth.\n"
      "• Fertilize lightly with organic compost.\n"
      "• Remove weeds regularly to avoid competition.";

  final String idealEnvironment =
      "• Climate: Cool to moderate climates.\n"
      "• Soil: Well-drained loamy soil with pH 6.0–7.0.\n"
      "• Temperature: Ideal growth between 13°C and 24°C.\n"
      "• Light: Full sunlight for at least 6 hours daily.";

  final String wateringTips =
      "• Water moderately to keep soil evenly moist.\n"
      "• Avoid overwatering to prevent bulb rot.\n"
      "• Reduce watering as bulbs mature and tops start to yellow.";

  final String sicknessInfo =
      "• Common Issues: White rot, downy mildew, nematodes.\n"
      "• Prevention: Rotate crops, use disease-free cloves.\n"
      "• Treatment: Remove infected plants and improve soil drainage.\n"
      "• Tip: Avoid planting garlic in the same soil consecutively to prevent soil-borne diseases.";

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
        title: const Text('Garlic 🧄'),
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
                'assets/garlic.jpg',
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
