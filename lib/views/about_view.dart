import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: const Icon(Icons.auto_awesome, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.appName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              AppConstants.appTitle,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Project Metadata', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 12),
                    Text('• Developer: Marlo Romero'),
                    Text('• Course: BSIT Mobile Programming'),
                    Text('• Architecture: MVVM with Provider'),
                    Text('• Backend: Supabase (PostgreSQL & RLS)'),
                    Text('• AI Models: Gemini 3.6 Flash & Groq Llama 3.3'),
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