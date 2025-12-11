import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'services.dart'; // Make sure this includes Plant model

/// ------------------- UserProfile -------------------
class UserProfile {
  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final int age;

  UserProfile({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.age,
  });

  factory UserProfile.fromMap(String uid, Map<dynamic, dynamic>? data) {
    final m = data ?? {};
    final dynamic ageVal = m['age'];
    final int parsedAge = ageVal is int
        ? ageVal
        : (ageVal is String ? int.tryParse(ageVal) ?? 0 : 0);

    return UserProfile(
      uid: uid,
      email: (m['email'] as String?) ?? '',
      fullName: (m['fullName'] as String?) ?? '',
      phone: (m['phone'] as String?) ?? '',
      age: parsedAge,
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'fullName': fullName,
    'phone': phone,
    'age': age,
  };
}

/// ------------------- Plant -------------------
class Plant {
  String id;
  String name;
  String description;
  String careGuide;
  String wateringSchedule;
  String imageUrl;
  String link;
  String ownerUid;

  Plant({
    required this.id,
    required this.name,
    required this.description,
    required this.careGuide,
    required this.wateringSchedule,
    required this.imageUrl,
    required this.link,
    required this.ownerUid,
  });

  factory Plant.fromMap(String id, Map<dynamic, dynamic> data) => Plant(
    id: id,
    name: (data['name'] as String?) ?? '',
    description: (data['description'] as String?) ?? '',
    careGuide: (data['careGuide'] as String?) ?? '',
    wateringSchedule: (data['wateringSchedule'] as String?) ?? '',
    imageUrl: (data['imageUrl'] as String?) ?? '',
    link: (data['link'] as String?) ?? '',
    ownerUid: (data['ownerUid'] as String?) ?? '',
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'careGuide': careGuide,
    'wateringSchedule': wateringSchedule,
    'imageUrl': imageUrl,
    'link': link,
    'ownerUid': ownerUid,
  };
}

/// ------------------- FeedbackModel -------------------
class FeedbackModel {
  final String id;
  final String userId;
  final String userName;
  final String comment;
  final DateTime timestamp;
  final int? rating;
  final List<String>? issues;
  final String? reply;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.timestamp,
    this.rating,
    this.issues,
    this.reply,
  });

  factory FeedbackModel.fromMap(String id, Map<dynamic, dynamic>? data) {
    final m = data ?? {};
    return FeedbackModel(
      id: id,
      userId: (m['userId'] as String?) ?? '',
      userName: (m['userName'] as String?) ?? '',
      comment: (m['comment'] as String?) ?? '',
      timestamp: DateTime.tryParse(m['timestamp'] ?? '') ?? DateTime.now(),
      rating: m['rating'] is int
          ? m['rating']
          : (m['rating'] is String ? int.tryParse(m['rating']) : null),
      issues: m['issues'] != null ? List<String>.from(m['issues']) : null,
      reply: m['reply'],
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'userName': userName,
    'comment': comment,
    'timestamp': timestamp.toIso8601String(),
    if (rating != null) 'rating': rating,
    if (issues != null) 'issues': issues,
    'reply': reply,
  };
}

/// ------------------- DatabaseService -------------------
class DatabaseService {
  final _db = FirebaseDatabase.instance.ref();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('users');

  /// -------- User Profile --------
  Future<UserProfile> getUserProfile(String uid) async {
    final snap = await _db.child('users/$uid').get();
    final data = snap.value as Map<dynamic, dynamic>?;
    return UserProfile.fromMap(uid, data);
  }

  Future<void> setUserProfile(UserProfile p) async {
    await _db.child('users/${p.uid}').set(p.toMap());
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> patch) async {
    await _db.child('users/$uid').update(patch);
  }

  Future<bool> isEmailRegistered(String email) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      for (var user in snapshot.children) {
        final data = user.value as Map<dynamic, dynamic>;
        if (data['email'] == email) return true;
      }
    }
    return false;
  }

  Future<void> updatePassword(String uid, String newPassword) async {
    await _dbRef.child(uid).update({'password': newPassword});
  }

  /// -------- Plants --------
  Stream<List<Plant>> allPlantsStream() {
    return _db.child('plants').onValue.map((event) {
      final root = event.snapshot.value;
      if (root is! Map) return <Plant>[];

      final List<Plant> acc = [];
      root.forEach((userId, plantsMap) {
        if (plantsMap is Map) {
          plantsMap.forEach((plantId, plantData) {
            if (plantData is Map) {
              final map = Map<dynamic, dynamic>.from(plantData);
              map['ownerUid'] = userId;
              acc.add(Plant.fromMap(plantId as String, map));
            }
          });
        }
      });
      return acc;
    });
  }

  Future<List<Plant>> allPlantsOnce() async {
    final snapshot = await _db.child('plants').get();
    final List<Plant> plants = [];
    if (snapshot.exists) {
      (snapshot.value as Map).forEach((userId, plantsMap) {
        if (plantsMap is Map) {
          plantsMap.forEach((plantId, plantData) {
            if (plantData is Map) {
              final map = Map<dynamic, dynamic>.from(plantData);
              map['ownerUid'] = userId;
              plants.add(Plant.fromMap(plantId as String, map));
            }
          });
        }
      });
    }
    return plants;
  }

  /// Add / Update / Delete Plants
  Future<void> createPlant(Plant plant, {String? ownerUid}) async {
    final uid = ownerUid ?? 'public';
    final ref = _db.child('plants/$uid').push();
    plant.id = ref.key!;
    plant.ownerUid = uid;
    await ref.set(plant.toMap());
  }

  Future<void> updatePlant(Plant plant, {String? ownerUid}) async {
    final uid = ownerUid ?? 'public';
    await _db.child('plants/$uid/${plant.id}').update(plant.toMap());
  }

  Future<void> deletePlant(String plantId, {String? ownerUid}) async {
    final uid = ownerUid ?? 'public';
    await _db.child('plants/$uid/$plantId').remove();
  }

  /// Admin functions
  Future<void> updatePlantAsAdmin(String ownerUid, Plant plant) async {
    await _db.child('plants/$ownerUid/${plant.id}').update(plant.toMap());
  }

  Future<void> deletePlantAsAdmin(String ownerUid, String plantId) async {
    await _db.child('plants/$ownerUid/$plantId').remove();
  }

  /// -------- User Record --------
  Future<void> createUserRecord(
      String uid,
      String email,
      String fullName, {
        required String phone,
        required int age,
      }) async {
    await _db.child('users/$uid').set({
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'age': age,
    });
  }

  /// -------- Feedback --------
  Stream<List<FeedbackModel>> feedbackStream() {
    return _db.child('feedbacks').onValue.map((event) {
      final root = event.snapshot.value;
      if (root is! Map) return <FeedbackModel>[];
      final List<FeedbackModel> acc = [];
      root.forEach((key, val) {
        if (val is Map) {
          acc.add(FeedbackModel.fromMap(
              key as String, Map<dynamic, dynamic>.from(val)));
        }
      });
      acc.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return acc;
    });
  }

  Future<void> addFeedback(FeedbackModel feedback) async {
    final ref = _db.child('feedbacks').push();
    await ref.set(feedback.toMap());
  }

  Future<void> sendReply(String feedbackId, String replyText) async {
    await _db.child('feedbacks/$feedbackId/reply').set(replyText);
  }
}

/// ------------------- AuthService -------------------
class AuthService {
  final _auth = FirebaseAuth.instance;
  final _dbService = DatabaseService();

  Future<User?> signUp(
      String email,
      String password,
      String fullName, {
        required String phone,
        required int age,
      }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      try {
        await user.updateDisplayName(fullName);
      } catch (_) {}
      await _dbService.createUserRecord(
        user.uid,
        email,
        fullName,
        phone: phone,
        age: age,
      );
    }
    return user;
  }

  Future<User?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
