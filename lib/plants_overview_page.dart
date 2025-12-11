import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'services.dart';

class PlantsOverviewPage extends StatefulWidget {
  const PlantsOverviewPage({Key? key}) : super(key: key);

  @override
  _PlantsOverviewPageState createState() => _PlantsOverviewPageState();
}

class _PlantsOverviewPageState extends State<PlantsOverviewPage> {
  late AudioPlayer _player;
  late FlutterTts tts;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    tts = FlutterTts();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildPlantCard(Plant p) {
    final imageWidget = p.imageUrl.startsWith('http')
        ? Image.network(
      p.imageUrl,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    )
        : Image.asset(
      p.imageUrl,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageWidget,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      children: [
                        const TextSpan(
                            text: 'Scientific Name: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: p.description),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      children: [
                        const TextSpan(
                            text: 'Habitat: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: p.careGuide),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      children: [
                        const TextSpan(
                            text: 'Category Type: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: p.wateringSchedule),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.green),
                  onPressed: () {
                    final textToRead =
                        "${p.name}. Scientific Name: ${p.description}. Common Name: ${p.careGuide}. Category: ${p.wateringSchedule}.";
                    tts.speak(textToRead);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.blueAccent),
                  onPressed: () {
                    Navigator.pushNamed(context, p.link);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plants Overview 🌿'),
        backgroundColor: Colors.green[600],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search plants...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Plant>>(
              stream: DatabaseService().allPlantsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final plants = snapshot.data ?? [];
                final filteredPlants = plants.where((p) {
                  final nameLower = p.name.toLowerCase();
                  final wateringLower = p.wateringSchedule.toLowerCase();
                  return nameLower.contains(_searchQuery) ||
                      wateringLower.contains(_searchQuery);
                }).toList();

                if (filteredPlants.isEmpty) {
                  return const Center(child: Text('No plants match your search 🌱'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredPlants.length,
                  itemBuilder: (ctx, i) => _buildPlantCard(filteredPlants[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
