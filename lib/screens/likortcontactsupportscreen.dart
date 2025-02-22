import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LikortContactSupportScreen extends StatelessWidget {
  const LikortContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? Scaffold(
            body: TextButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/likortlogin'),
                child: const Text('Login')),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Contact Support'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need help? We\'re here to assist you.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildContactOption(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () => _launchEmail('support@example.com'),
                  ),
                  _buildContactOption(
                    icon: Icons.phone,
                    label: 'Phone',
                    onTap: () => _launchPhone('123-456-7890'),
                  ),
                  // Add more contact options as needed
                ],
              ),
            ),
          );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Handle error
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      // Handle error
    }
  }
}
