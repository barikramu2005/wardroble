import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/cloth.dart';

class RecommendationScreen extends StatefulWidget {
  final Box<Cloth> clothesBox;

  const RecommendationScreen({
    super.key,
    required this.clothesBox,
  });

  @override
  State<RecommendationScreen> createState() =>
      _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  Cloth? selectedCloth;
  Cloth? recommendedCloth;

  String selectedOccasion = 'Daily';

  final Set<int> triedKeys = {}; // prevents repeats

  // ---------- HELPERS ----------
  bool isTop(Cloth c) =>
      c.type == 'T-shirt' || c.type == 'Shirt';

  bool isBottom(Cloth c) =>
      c.type == 'Jeans' || c.type == 'Trousers';

  bool isNeutralColor(String color) =>
      ['Black', 'White', 'Grey', 'Blue'].contains(color);

  bool isGoodColorMatch(Cloth a, Cloth b) {
    if (isNeutralColor(a.color)) return true;
    if (isNeutralColor(b.color)) return true;
    return false;
  }

  // ---------- CORE RECOMMENDATION ----------
  void recommend({bool retry = false}) {
    if (selectedCloth == null) return;

    final candidates = widget.clothesBox.values.where((c) {
      if (c.state != ClothState.ready) return false;

      // prevent repeats on retry
      if (retry && c.key != null && triedKeys.contains(c.key)) {
        return false;
      }

      if (isTop(selectedCloth!) && isBottom(c)) return true;
      if (isBottom(selectedCloth!) && isTop(c)) return true;

      return false;
    }).toList();

    if (candidates.isEmpty) {
      setState(() => recommendedCloth = null);
      return;
    }

    // Sort by:
    // 1. Occasion match
    // 2. Preference score
    candidates.sort((a, b) {
      final aOccasion = a.category == selectedOccasion ? 1 : 0;
      final bOccasion = b.category == selectedOccasion ? 1 : 0;

      if (aOccasion != bOccasion) {
        return bOccasion.compareTo(aOccasion);
      }

      return b.preferenceScore.compareTo(a.preferenceScore);
    });

    for (final c in candidates) {
      if (isGoodColorMatch(selectedCloth!, c)) {
        setState(() {
          recommendedCloth = c;
          if (c.key != null) triedKeys.add(c.key as int);
        });
        return;
      }
    }

    setState(() => recommendedCloth = null);
  }

  void acceptRecommendation() {
    if (recommendedCloth == null) return;

    setState(() {
      recommendedCloth!.preferenceScore++;
      recommendedCloth!.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    final readyClothes = widget.clothesBox.values
        .where((c) => c.state == ClothState.ready)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfit Suggestion'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- OCCASION ----------
            DropdownButton<String>(
              value: selectedOccasion,
              isExpanded: true,
              items: ['Daily', 'Casual', 'Party']
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  selectedOccasion = v!;
                  triedKeys.clear();
                  recommendedCloth = null;
                });
              },
            ),

            const SizedBox(height: 12),

            const Text(
              'Pick a cloth',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // ---------- CLOTH SELECTION ----------
            SizedBox(
              height: 150,
              child: readyClothes.isEmpty
                  ? const Center(
                child: Text('No clean clothes available'),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: readyClothes.length,
                itemBuilder: (context, index) {
                  final cloth = readyClothes[index];
                  final isSelected =
                      selectedCloth == cloth;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCloth = cloth;
                        triedKeys.clear();
                        recommendedCloth = null;
                      });
                    },
                    child: Container(
                      width: 110,
                      margin:
                      const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Colors.green
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.file(
                              File(cloth.imagePath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cloth.type,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            cloth.color,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // ---------- BUTTONS ----------
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedCloth == null
                        ? null
                        : () => recommend(),
                    child: const Text('Suggest'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: recommendedCloth == null
                        ? null
                        : () => recommend(retry: true),
                    child: const Text('Try Another'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ---------- RESULT ----------
            Expanded(
              child: Center(
                child: recommendedCloth == null
                    ? const Text(
                  'No suggestion yet',
                  style: TextStyle(color: Colors.grey),
                )
                    : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.file(
                      File(recommendedCloth!.imagePath),
                      height: 180,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${recommendedCloth!.type} (${recommendedCloth!.color})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: acceptRecommendation,
                      child: const Text('I like this 👍'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
