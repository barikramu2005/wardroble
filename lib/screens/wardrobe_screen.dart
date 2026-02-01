import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/cloth.dart';
import 'add_cloth_screen.dart';

class WardrobeScreen extends StatefulWidget {
  final Box<Cloth> clothesBox;

  const WardrobeScreen({
    super.key,
    required this.clothesBox,
  });

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  final List<String> clothTypeOrder = [
    'T-shirt',
    'Shirt',
    'Jeans',
    'Trousers',
  ];

  // ---------- HELPERS ----------
  Color getStateColor(ClothState state) {
    switch (state) {
      case ClothState.ready:
        return Colors.green;
      case ClothState.needIron:
        return Colors.blue;
      case ClothState.needWash:
        return Colors.orange;
    }
  }

  int statePriority(ClothState state) {
    switch (state) {
      case ClothState.ready:
        return 0;
      case ClothState.needIron:
        return 1;
      case ClothState.needWash:
        return 2;
    }
  }

  Map<String, List<Cloth>> groupClothes(List<Cloth> clothes) {
    final Map<String, List<Cloth>> grouped = {};

    for (final type in clothTypeOrder) {
      final items = clothes.where((c) => c.type == type).toList();
      items.sort(
            (a, b) => statePriority(a.state).compareTo(statePriority(b.state)),
      );
      grouped[type] = items;
    }
    return grouped;
  }

  // ---------- ACTIONS ----------
  void openClothActions(Cloth c) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Cloth'),
              onTap: () async {
                Navigator.pop(context);
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddClothScreen(existingCloth: c),
                  ),
                );
                if (updated == true) setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Cloth',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                confirmDelete(c);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Change State'),
              onTap: () {
                Navigator.pop(context);
                openStateEditor(c);
              },
            ),
          ],
        );
      },
    );
  }

  void confirmDelete(Cloth c) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete Cloth'),
          content: Text(
            'Delete this ${c.type} (${c.color}) permanently?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                c.delete(); // Hive delete
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void openStateEditor(Cloth c) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Mark as READY'),
              onTap: () {
                setState(() {
                  c.state = ClothState.ready;
                  c.usedCount = 0;
                  c.save();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Mark as NEED WASH'),
              onTap: () {
                setState(() {
                  c.state = ClothState.needWash;
                  c.usedCount = c.maxUses;
                  c.save();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Mark as NEED IRON'),
              onTap: () {
                setState(() {
                  c.state = ClothState.needIron;
                  c.save();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // ---------- TILE ----------
  Widget buildClothTile(Cloth c) {
    return InkWell(
      onLongPress: () => openClothActions(c),
      child: ListTile(
        leading: Stack(
          children: [
            Image.file(
              File(c.imagePath),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 6,
                backgroundColor: getStateColor(c.state),
              ),
            ),
          ],
        ),
        title: Text('${c.type} (${c.color})'),
        subtitle: Text(
          'Uses: ${c.usedCount}/${c.maxUses} • ${c.state.name.toUpperCase()}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.check),
          onPressed: c.state != ClothState.ready
              ? null
              : () {
            setState(() {
              c.usedCount++;
              if (c.usedCount >= c.maxUses) {
                c.state = ClothState.needWash;
              }
              c.save();
            });
          },
        ),
      ),
    );
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final clothes = widget.clothesBox.values.toList();
    final grouped = groupClothes(clothes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe'),
        centerTitle: true,
      ),
      body: clothes.isEmpty
          ? const Center(child: Text('No clothes added yet'))
          : ListView(
        padding: const EdgeInsets.all(8),
        children: grouped.entries.map((entry) {
          if (entry.value.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  entry.key.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...entry.value.map(buildClothTile),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddClothScreen()),
          );
          if (result != null && result is Cloth) {
            widget.clothesBox.add(result);
            setState(() {});
          }
        },
      ),
    );
  }
}
