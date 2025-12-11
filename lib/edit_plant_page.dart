import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services.dart';
import 'validator2.dart';

class EditPlantPage extends StatefulWidget {
  static const routeName = '/editPlant';

  final Plant plant;
  final String ownerUid;

  const EditPlantPage({
    required this.plant,
    required this.ownerUid,
    Key? key,
  }) : super(key: key);

  @override
  _EditPlantPageState createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  late TextEditingController _nameController;

  String? _selectedCategory;
  String? _selectedScientificName;
  String? _selectedHabitat;
  String? _selectedRoute;

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);

    _selectedScientificName = _scientificNames.contains(widget.plant.description)
        ? widget.plant.description
        : null;
    _selectedHabitat = _habitatList.contains(widget.plant.careGuide)
        ? widget.plant.careGuide
        : null;
    _selectedCategory = _categoryTypes.contains(widget.plant.wateringSchedule)
        ? widget.plant.wateringSchedule
        : null;
    _selectedRoute = _plantRoutes.contains(widget.plant.link)
        ? widget.plant.link
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _pickedImage = File(pickedFile.path));
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) setState(() => _pickedImage = File(pickedFile.path));
  }

  Widget imagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: _pickedImage != null
          ? Image.file(_pickedImage!, height: 220, width: double.infinity, fit: BoxFit.cover)
          : buildImageWidget(widget.plant.imageUrl),
    );
  }

  Widget buildImageWidget(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallbackImageLarge(),
      );
    }
    final file = File(url);
    if (file.existsSync()) {
      return Image.file(file, height: 220, width: double.infinity, fit: BoxFit.cover);
    }
    return fallbackImageLarge();
  }

  Widget fallbackImageLarge() {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
    );
  }

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
          decoration: InputDecoration(labelText: title, hintText: "Enter new $title"),
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
        list.insert(list.length - 1, result);
        onSelected(result);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedPlant = Plant(
      id: widget.plant.id,
      name: _nameController.text.trim(),
      description: _selectedScientificName ?? '',
      careGuide: _selectedHabitat ?? '',
      wateringSchedule: _selectedCategory ?? '',
      imageUrl: _pickedImage?.path ?? widget.plant.imageUrl,
      ownerUid: widget.plant.ownerUid,
      link: _selectedRoute ?? '',
    );

    try {
      await DatabaseService().updatePlant(updatedPlant);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating plant: $e")),
      );
    }
  }

  Widget buildDropdown({
    required String label,
    required String? selectedValue,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue != null && items.contains(selectedValue) ? selectedValue : null,
      decoration: InputDecoration(labelText: label, filled: true),
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Please select $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Plant"),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
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
                  const SizedBox(width: 12),
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
                decoration: const InputDecoration(labelText: "Plant Name"),
                validator: PlantValidator.validatePlantName,
              ),
              const SizedBox(height: 15),

              buildDropdown(
                label: 'Scientific Name',
                selectedValue: _selectedScientificName,
                items: _scientificNames,
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
              ),
              const SizedBox(height: 15),

              buildDropdown(
                label: 'Habitat',
                selectedValue: _selectedHabitat,
                items: _habitatList,
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
              ),
              const SizedBox(height: 15),

              buildDropdown(
                label: 'Category Type',
                selectedValue: _selectedCategory,
                items: _categoryTypes,
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
              ),
              const SizedBox(height: 15),

              buildDropdown(
                label: 'Plant Info Page Route',
                selectedValue: _selectedRoute,
                items: _plantRoutes,
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
              ),
              const SizedBox(height: 25),

              ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
