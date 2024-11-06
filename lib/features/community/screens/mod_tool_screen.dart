import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolScreen extends StatelessWidget {
  final String name;
  const ModToolScreen({super.key, required this.name});
  void navigateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Mod Tools'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Add Moderators'),
              leading: const Icon(Icons.add_moderator),
              onTap: () => navigateToAddMods(context),
            ),
            ListTile(
              title: const Text('Edit Community'),
              leading: const Icon(Icons.edit),
              onTap: () => navigateToEditCommunity(context),
            ),
          ],
        ),
      ),
    );
  }
}
