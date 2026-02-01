import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.70, // ✅ smaller drawer
      child: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Center(
                child: Text(
                  'Wardrobe\nBuilt by Bibhuti Bhusan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Instagram'),
              onTap: () {
                _openUrl('https://www.instagram.com/bibhuti_._op');
              },
            ),

            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('GitHub'),
              onTap: () {
                _openUrl('https://github.com/barikramu2005');
              },
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '© 2026 • Personal Project',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
