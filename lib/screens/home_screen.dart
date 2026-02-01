import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/cloth.dart';
import '../widgets/app_drawer.dart';
import 'recommendation_screen.dart';
import 'laundry_screen.dart';

class HomeScreen extends StatelessWidget {
  final Box<Cloth> clothesBox;

  const HomeScreen({
    super.key,
    required this.clothesBox,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // ✅ Drawer only on Home

      appBar: AppBar(
        title: const Text('My Wardrobe'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'What should I wear today?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // ---------- OUTFIT ----------
            ElevatedButton.icon(
              icon: const Icon(Icons.checkroom),
              label: const Text('Get Outfit Suggestion'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecommendationScreen(
                      clothesBox: clothesBox,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 16),

            // ---------- LAUNDRY ----------
            ElevatedButton.icon(
              icon: const Icon(Icons.local_laundry_service),
              label: const Text('Laundry Mode'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LaundryScreen(
                      clothesBox: clothesBox,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 24),

            // ---------- HOW IT WORKS ----------
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'How it works',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• Add your clothes with photos'),
                    Text('• App tracks clean & dirty clothes'),
                    Text('• Get outfit suggestions'),
                    Text('• Laundry mode keeps things clean'),
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
