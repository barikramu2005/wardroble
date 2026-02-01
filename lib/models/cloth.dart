import 'package:hive/hive.dart';

part 'cloth.g.dart';

/// ===============================
/// CLOTH STATE
/// ===============================
@HiveType(typeId: 0)
enum ClothState {
  @HiveField(0)
  ready,

  @HiveField(1)
  needWash,

  @HiveField(2)
  needIron,
}

/// ===============================
/// CLOTH MODEL
/// ===============================
@HiveType(typeId: 1)
class Cloth extends HiveObject {
  // ---------- BASIC INFO ----------
  @HiveField(0)
  String type; // T-shirt, Shirt, Jeans, Trousers

  @HiveField(1)
  String category; // Daily, Casual, Party

  @HiveField(2)
  String color;

  @HiveField(3)
  String imagePath;

  // ---------- USAGE TRACKING ----------
  @HiveField(4)
  int usedCount;

  @HiveField(5)
  int maxUses;

  // ---------- STATE ----------
  @HiveField(6)
  ClothState state;

  // ---------- PREFERENCE LEARNING ----------
  @HiveField(7)
  int preferenceScore;

  Cloth({
    required this.type,
    required this.category,
    required this.color,
    required this.imagePath,
    required this.maxUses,
    this.usedCount = 0,
    this.state = ClothState.ready,
    this.preferenceScore = 0,
  });
}
