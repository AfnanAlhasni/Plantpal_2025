import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'services.dart';
import 'validator2.dart';

class AddPlantPage extends StatefulWidget {
  static const routeName = '/addPlant';
  const AddPlantPage({Key? key}) : super(key: key);

  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _selectedCategory;
  String? _selectedScientificName;
  String? _selectedHabitat;
  String? _selectedRoute;

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // ------------------------------
  // Dropdown Base Lists + Add New
  // ------------------------------
  final List<String> _categoryTypes = [
    'Flowering Plants',
    'Fruit Trees',
    'Herbal Plants',
    'Vegetable Plants',
    'Add New Category Type...'
  ];

  final List<String> _scientificNames = [
    "Malus domestica",
    "Musa spp.",
    "Ocimum basilicum",
    "Bougainvillea glabra",
    "Brassica oleracea var. italica",
    "Brassica oleracea var. capitata",
    "Daucus carota",
    "Phoenix dactylifera",
    "Adenium obesum",
    "Anethum graveolens",
    "Solanum melongena",
    "Allium sativum",
    "Jasminum officinale",
    "Mangifera indica",
    "Mentha spp.",
    "Moringa oleifera",
    "Petroselinum crispum",
    "Punica granatum",
    "Solanum tuberosum",
    "Salvia officinalis",
    "Solanum lycopersicum",
    "Add New Scientific Name..."
  ];

  final List<String> _habitatList = [
    "Temperate regions, orchards, irrigated farms",
    "Tropical and subtropical regions, plantations",
    "Gardens, pots, and farms with partial sun",
    "Gardens, parks, and urban landscaping",
    "Cool, fertile soils, well-drained fields",
    "Cool, fertile soils, well-drained fields",
    "Fertile, well-drained soil, sunny areas",
    "Arid and semi-arid regions, oases, farms",
    "Arid to semi-arid regions, rocky soils",
    "Sunny gardens, well-drained soil",
    "Warm climates, irrigated fields or gardens",
    "Sunny gardens, well-drained soil",
    "Gardens, parks, or home cultivation",
    "Tropical and subtropical regions, orchards",
    "Gardens, pots, and partial sun areas",
    "Tropical and subtropical regions, dry soils",
    "Fertile, well-drained soils, gardens",
    "Arid to semi-arid regions, orchards",
    "Cool, fertile soils, irrigated fields",
    "Sunny gardens, well-drained soils",
    "Warm, sunny gardens or farms",
    "Add New Habitat..."
  ];

  final List<String> _plantRoutes = [
    '/Apple',
    '/Banana',
    '/Basil',
    '/Bougainvillea',
    '/Broccoli',
    '/Cabbage',
    '/Carrot',
    '/Date Palm',
    '/Desert rose',
    '/Dill',
    '/Eggplant',
    '/Garlic',
    '/Jasmine',
    '/Mango',
    '/Mint',
    '/Moringa',
    '/Parsley',
    '/Pomegranate',
    '/Potato',
    '/Sage',
    '/Tomato',
    'Add New Route...'
  ];

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('plants');

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<bool> _plantExists(String name) async {
    final snapshot = await _dbRef.get();
    if (!snapshot.exists) return false;

    final lowerName = name.trim().toLowerCase();

    for (final child in snapshot.children) {
      final plantName = (child.child('name').value ?? '').toString().toLowerCase();
      if (plantName == lowerName) return true;
    }
    return false;
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _pickedImage = File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _pickedImage = File(pickedFile.path));
    }
  }

  // ⭐ UNIVERSAL FUNCTION — add new dropdown value
  Future<void> _addNewItem({
    required String title,
    required List<String> list,
    required void Function(String) onSelected,
  }) async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            hintText: "Enter new $title",
          ),
        ),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        list.insert(list.length - 1, result); // insert before "Add New …"
        onSelected(result);
      });
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick or capture an image")),
      );
      return;
    }

    final name = _nameController.text.trim();
    final exists = await _plantExists(name);

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ A plant named "$name" already exists!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final plant = Plant(
      id: '',
      name: name,
      description: _selectedScientificName ?? '',
      careGuide: _selectedHabitat ?? '',
      wateringSchedule: _selectedCategory ?? '',
      imageUrl: _pickedImage!.path,
      ownerUid: 'public',
      link: _selectedRoute ?? '',
    );

    try {
      await DatabaseService().createPlant(plant);

      await FirebaseDatabase.instance.ref('notifications/newPlant').set({
        'plantName': plant.name,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Plant added successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, plant.name);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding plant: $e')),
      );
    }
  }

  Widget imagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: _pickedImage != null
          ? Image.file(_pickedImage!, height: 200, width: double.infinity, fit: BoxFit.cover)
          : Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[200],
        child: Icon(Icons.photo, size: 80, color: Colors.grey[600]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Plant'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                imagePreview(),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(Icons.photo),
                        label: const Text("Gallery"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImageFromCamera,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Camera"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Plant Name',
                    filled: true,
                  ),
                  validator: PlantValidator.validatePlantName,
                ),

                const SizedBox(height: 16),

                // ⭐ SCIENTIFIC NAME DROPDOWN
                DropdownButtonFormField<String>(
                  value: _selectedScientificName,
                  decoration: const InputDecoration(
                    labelText: 'Scientific Name',
                    filled: true,
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _scientificNames
                      .map((name) => DropdownMenuItem(
                    value: name,
                    child: Text(name, overflow: TextOverflow.ellipsis),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value == "Add New Scientific Name...") {
                      _addNewItem(
                        title: "Scientific Name",
                        list: _scientificNames,
                        onSelected: (val) => _selectedScientificName = val,
                      );
                    } else {
                      setState(() => _selectedScientificName = value);
                    }
                  },
                  validator: (value) => value == null ? 'Please select a scientific name' : null,
                ),

                const SizedBox(height: 16),

                // ⭐ HABITAT DROPDOWN
                DropdownButtonFormField<String>(
                  value: _selectedHabitat,
                  decoration: const InputDecoration(
                    labelText: 'Habitat',
                    filled: true,
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _habitatList
                      .map((h) => DropdownMenuItem(
                    value: h,
                    child: Text(h, overflow: TextOverflow.ellipsis),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value == "Add New Habitat...") {
                      _addNewItem(
                        title: "Habitat",
                        list: _habitatList,
                        onSelected: (val) => _selectedHabitat = val,
                      );
                    } else {
                      setState(() => _selectedHabitat = value);
                    }
                  },
                  validator: (value) => value == null ? 'Please select a habitat' : null,
                ),

                const SizedBox(height: 16),

                // ⭐ CATEGORY TYPE DROPDOWN
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category Type',
                    filled: true,
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _categoryTypes
                      .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c, overflow: TextOverflow.ellipsis),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value == "Add New Category Type...") {
                      _addNewItem(
                        title: "Category Type",
                        list: _categoryTypes,
                        onSelected: (val) => _selectedCategory = val,
                      );
                    } else {
                      setState(() => _selectedCategory = value);
                    }
                  },
                  validator: (value) => value == null ? 'Please select a category type' : null,
                ),

                const SizedBox(height: 16),

                // ⭐ PLANT INFO PAGE ROUTE DROPDOWN
                DropdownButtonFormField<String>(
                  value: _selectedRoute,
                  decoration: const InputDecoration(
                    labelText: 'Plant Info Page Route',
                    filled: true,
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _plantRoutes
                      .map((r) => DropdownMenuItem(
                    value: r,
                    child: Text(r, overflow: TextOverflow.ellipsis),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value == "Add New Route...") {
                      _addNewItem(
                        title: "Plant Info Route",
                        list: _plantRoutes,
                        onSelected: (val) => _selectedRoute = val,
                      );
                    } else {
                      setState(() => _selectedRoute = value);
                    }
                  },
                  validator: (value) => value == null ? 'Please select a route' : null,
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: _onSave,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Plant'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
