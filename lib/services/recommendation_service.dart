import 'package:firebase_database/firebase_database.dart';
import 'package:plantpal_2025/services.dart';


class RecommendationService {
  /// ---------------- Plant Categories ----------------
  static final Map<String, String> plantCategory = {
    "tomato": "Vegetable Plants",
    "cucumber": "Vegetable Plants",
    "eggplant": "Vegetable Plants",
    "mint": "Herbal Plants",
    "basil": "Herbal Plants",
    "date palm": "Fruit Trees",
    "lemon": "Fruit Trees",
    "rose": "Flowering Plants",
    "hibiscus": "Flowering Plants",
    "bougainvillea":"Flowering Plants",
    "broccoli":"Vegetable Plants",
    "cabbage":"Vegetable Plants",
    "carrot":"Vegetable Plants",
    "dessert rose":"Flowering Plants",
    "dill":"Herbal Plants",
    "mango":"Fruit Trees",
    "parsley":"Herbal Plants",
    "potato":"Vegetable Plants",
    "sage":"Herbal Plants",
    "apple":"Fruit Trees",
    "Banana Tree":"Fruit Trees",
    "Garlic":"Vegetable Plants",
    "Jasmine":"Flowering Plants",
    "Pomegranate":"Fruit Trees"
  };

  /// ---------------- Track User Interaction ----------------
  /// Call this whenever a user views a plant
  static void trackPlantInteraction(String userId, String plantName) {
    final category = plantCategory[plantName.toLowerCase()] ?? "unknown";
    FirebaseDatabase.instance
        .ref("interactions/$userId/$category")
        .set(ServerValue.increment(1));
  }

  /// ---------------- Get Top Category for User ----------------
  static Future<String?> getTopCategory(String userId) async {
    final snapshot = await FirebaseDatabase.instance
        .ref("interactions/$userId")
        .get();

    if (!snapshot.exists) return null;

    final Map data = snapshot.value as Map;
    String? topCategory;
    int maxCount = -1;

    data.forEach((key, value) {
      if (value is int && value > maxCount) {
        maxCount = value;
        topCategory = key;
      }
    });

    return topCategory;
  }

  /// ---------------- Get Recommended Plants ----------------
  /// Returns a list of plants from the top category the user interacted with
  static Future<List<Plant>> getRecommendedPlants(String userId) async {
    final topCategory = await getTopCategory(userId);
    if (topCategory == null) return [];

    final allPlants = await DatabaseService().allPlantsOnce();

    return allPlants
        .where((p) => plantCategory[p.name.toLowerCase()] == topCategory)
        .toList();
  }
}
