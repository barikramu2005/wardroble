import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/cloth.dart';

class LaundryScreen extends StatefulWidget {
  final Box<Cloth> clothesBox;

  const LaundryScreen({
    super.key,
    required this.clothesBox,
  });

  @override
  State<LaundryScreen> createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {
  final Set<Cloth> selectedClothes = {};

  ClothState? activeSelectionState;

  @override
  Widget build(BuildContext context) {
    final laundryClothes = widget.clothesBox.values.where(
          (c) =>
      c.state == ClothState.needWash ||
          c.state == ClothState.needIron,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Mode'),
        centerTitle: true,
      ),

      // ---------- BODY ----------
      body: laundryClothes.isEmpty
          ? const Center(
        child: Text('No clothes need laundry 🎉'),
      )
          : ListView.builder(
        itemCount: laundryClothes.length,
        itemBuilder: (context, index) {
          final cloth = laundryClothes[index];
          final isSelected = selectedClothes.contains(cloth);
          final isDisabled = activeSelectionState != null &&
              cloth.state != activeSelectionState;

          return ListTile(
            enabled: !isDisabled,
            leading: Icon(
              isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: isSelected ? Colors.green : null,
            ),
            title: Text('${cloth.type} (${cloth.color})'),
            subtitle: Text(
              cloth.state == ClothState.needWash
                  ? 'Needs Wash'
                  : 'Needs Iron',
            ),
            tileColor: isSelected
                ? Colors.green.withOpacity(0.15)
                : null,
            onTap: isDisabled
                ? null
                : () {
              setState(() {
                if (isSelected) {
                  selectedClothes.remove(cloth);
                  if (selectedClothes.isEmpty) {
                    activeSelectionState = null;
                  }
                } else {
                  selectedClothes.add(cloth);
                  activeSelectionState = cloth.state;
                }
              });
            },
          );
        },
      ),

      // ---------- BOTTOM ACTION BAR ----------
      bottomNavigationBar: selectedClothes.isEmpty
          ? null
          : Container(
        padding: const EdgeInsets.all(12),
        color: Colors.grey.shade200,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: activeSelectionState ==
                    ClothState.needWash
                    ? markSelectedAsWashed
                    : null,
                child: const Text('Mark Washed'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: activeSelectionState ==
                    ClothState.needIron
                    ? markSelectedAsIroned
                    : null,
                child: const Text('Mark Ironed'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- ACTIONS ----------
  void markSelectedAsWashed() {
    setState(() {
      for (final cloth in selectedClothes) {
        cloth.state = ClothState.needIron;
        cloth.save();
      }
      selectedClothes.clear();
      activeSelectionState = null;
    });
  }

  void markSelectedAsIroned() {
    setState(() {
      for (final cloth in selectedClothes) {
        cloth.state = ClothState.ready;
        cloth.usedCount = 0;
        cloth.save();
      }
      selectedClothes.clear();
      activeSelectionState = null;
    });
  }
}
