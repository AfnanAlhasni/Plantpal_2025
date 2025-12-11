import 'package:flutter/material.dart';
import 'services.dart';
import 'edit_plant_page.dart';

class UpdateDeletePage extends StatefulWidget {
  static const routeName = '/updateDelete';
  @override
  _UpdateDeletePageState createState() => _UpdateDeletePageState();
}

class _UpdateDeletePageState extends State<UpdateDeletePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update / Delete Plants 🌿'),
        backgroundColor: Colors.green[700],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a plant...',
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
                    final descLower = p.description.toLowerCase();
                    final careLower = p.careGuide.toLowerCase();
                    final waterLower = p.wateringSchedule.toLowerCase();
                    return nameLower.contains(_searchQuery) ||
                        descLower.contains(_searchQuery) ||
                        careLower.contains(_searchQuery) ||
                        waterLower.contains(_searchQuery);
                  }).toList();

                  if (filteredPlants.isEmpty) {
                    return const Center(
                      child: Text('No plants match your search 🌱'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredPlants.length,
                    itemBuilder: (ctx, i) {
                      final p = filteredPlants[i];

                      // 🌿 Image with graceful fallback
                      final imageWidget = p.imageUrl.startsWith('http')
                          ? Image.network(
                        p.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          ),
                        ),
                      )
                          : Image.asset(
                        p.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          ),
                        ),
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                        children: [
                                          const TextSpan(
                                              text: 'Scientific Name: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(text: p.description),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                        children: [
                                          const TextSpan(
                                              text: 'Habitat: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(text: p.careGuide),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                        children: [
                                          const TextSpan(
                                              text: 'Category Type: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
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
                                    icon: const Icon(Icons.info_outline,
                                        color: Colors.green),
                                    onPressed: () {
                                      Navigator.pushNamed(context, p.link);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () async {
                                      final updated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditPlantPage(
                                            plant: p,
                                            ownerUid: p.ownerUid,
                                          ),
                                        ),
                                      );
                                      if (updated == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Plant updated successfully ✅")),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      final ok = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title:
                                          const Text('Confirm Delete'),
                                          content: const Text(
                                              'Are you sure you want to delete this plant?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (ok == true) {
                                        await DatabaseService()
                                            .deletePlant(p.id);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
