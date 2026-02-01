import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/cloth.dart';

class AddClothScreen extends StatefulWidget {
  final Cloth? existingCloth;

  const AddClothScreen({
    super.key,
    this.existingCloth,
  });

  @override
  State<AddClothScreen> createState() => _AddClothScreenState();
}

class _AddClothScreenState extends State<AddClothScreen> {
  final ImagePicker picker = ImagePicker();
  File? image;

  String type = 'T-shirt';
  String category = 'Daily';
  String color = 'Black';

  @override
  void initState() {
    super.initState();
    if (widget.existingCloth != null) {
      final c = widget.existingCloth!;
      type = c.type;
      category = c.category;
      color = c.color;
      image = File(c.imagePath);
    }
  }

  int getMaxUses(String type) {
    switch (type) {
      case 'T-shirt':
      case 'Shirt':
        return 1;
      case 'Jeans':
        return 3;
      case 'Trousers':
        return 2;
      default:
        return 1;
    }
  }

  Future<void> captureImage() async {
    final XFile? photo =
    await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        image = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingCloth != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Cloth' : 'Add Cloth'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: captureImage,
            child: Container(
              height: 180,
              color: Colors.grey.shade300,
              child: image == null
                  ? const Center(child: Text('Tap to capture image'))
                  : Image.file(image!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),

          DropdownButton<String>(
            value: type,
            isExpanded: true,
            items: ['T-shirt', 'Shirt', 'Jeans', 'Trousers']
                .map((e) =>
                DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => type = v!),
          ),

          DropdownButton<String>(
            value: category,
            isExpanded: true,
            items: ['Daily', 'Casual', 'Party']
                .map((e) =>
                DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => category = v!),
          ),

          DropdownButton<String>(
            value: color,
            isExpanded: true,
            items: ['Black', 'White', 'Blue', 'Grey', 'Brown']
                .map((e) =>
                DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => color = v!),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: image == null
                ? null
                : () {
              if (isEdit) {
                final c = widget.existingCloth!;
                c.type = type;
                c.category = category;
                c.color = color;
                c.imagePath = image!.path;
                c.maxUses = getMaxUses(type);
                c.save();
                Navigator.pop(context, true);
              } else {
                Navigator.pop(
                  context,
                  Cloth(
                    type: type,
                    category: category,
                    color: color,
                    imagePath: image!.path,
                    maxUses: getMaxUses(type),
                  ),
                );
              }
            },
            child: Text(isEdit ? 'Save Changes' : 'Add Cloth'),
          ),
        ],
      ),
    );
  }
}
