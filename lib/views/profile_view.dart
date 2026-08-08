import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/profile_card.dart';
import '../widgets/primary_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (user != null) ProfileCard(user: user),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.school_outlined),
                    title: Text('Course'),
                    subtitle: Text('MITS 006- Mobile Programming'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.code_rounded),
                    title: Text('Architecture'),
                    subtitle: Text('MVVM Pattern with Provider'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.storage_rounded),
                    title: Text('Database'),
                    subtitle: Text('Supabase'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Sign Out',
              onPressed: () => authProvider.logout(),
            ),
          ],
        ),
      ),
    );
  }
}