import 'package:flutter/material.dart';

class Parsley extends StatefulWidget {
  static const routeName = '/Parsley';

  const Parsley({super.key});

  @override
  _ParsleyState createState() => _ParsleyState();
}

class _ParsleyState extends State<Parsley> {
  String _searchQuery = '';

  final String description =
      "Parsley (Petroselinum crispum) is a versatile herb commonly used in Omani cuisine "
      "for garnishing and flavoring dishes. It has bright green, curly or flat leaves "
      "and is rich in vitamins and antioxidants.";

  final String careInstructions =
      "• Sow seeds in well-drained, fertile soil.\n"
      "• Thin seedlings to 15–20 cm apart.\n"
      "• Keep soil moist but not waterlogged.\n"
      "• Harvest outer leaves regularly to encourage new growth.\n"
      "• Fertilize lightly with organic compost.";

  final String idealEnvironment =
      "• Climate: Prefers cooler months; grows well in partial sun.\n"
      "• Soil: Loamy soil with pH 6.0–7.0.\n"
      "• Temperature: Ideal growth between 15°C–24°C.\n"
      "• Light: Partial to full sunlight (4–6 hours daily).";

  final String wateringTips =
      "• Water regularly to maintain evenly moist soil.\n"
      "• Avoid overwatering to prevent root rot.\n"
      "• Container-grown parsley requires more frequent watering.\n"
      "• Mulch to retain moisture and reduce weeds.";

  final String sicknessInfo =
      "• Common Issues: Aphids, leaf spot, and downy mildew.\n"
      "• Prevention: Provide good air circulation and avoid overcrowding.\n"
      "• Treatment: Spray neem oil or mild insecticidal soap.\n"
      "• Tip: Remove affected leaves promptly to prevent spread.";

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
        title: const Text('Parsley 🌿'),
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
                'assets/Parsley.jpg',
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
