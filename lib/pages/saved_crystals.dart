// lib/saved_crystals_page.dart

import 'package:flutter/material.dart';
import 'package:coda/db_stuff/crystal_info.dart';
import 'package:coda/db_stuff/database_helper.dart'; // Import your DatabaseHelper

class SavedCrystalsPage extends StatefulWidget {
  const SavedCrystalsPage({super.key});

  @override
  State<SavedCrystalsPage> createState() => _SavedCrystalsPageState();
}

class _SavedCrystalsPageState extends State<SavedCrystalsPage> {
  // List to hold the CrystalInfo objects fetched from the database
  List<CrystalInfo> _savedCrystals = [];
  bool _isLoading = true; // To show a loading indicator while fetching
  String? _errorMessage;

  // Instance of our DatabaseHelper
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSavedCrystals(); // Load crystals when the page initializes
  }

  // Method to fetch all saved crystals from the database
  Future<void> _loadSavedCrystals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final crystals = await _dbHelper.getCrystalInfoList(); // Use the helper to get the list
      setState(() {
        _savedCrystals = crystals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading saved crystals: $e';
        _isLoading = false;
      });
    }
  }

  // Method to delete a crystal from the database
  Future<void> _deleteCrystal(String codId) async {
    try {
      await _dbHelper.deleteCrystalInfo(codId);
      // After deletion, refresh the list
      _loadSavedCrystals();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Crystal with COD ID $codId deleted.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete crystal: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Placeholder for future edit functionality
  void _editCrystal(CrystalInfo crystal) {
    // TODO: Implement navigation to a new page or a dialog for editing
    // For now, let's just print to console
    print('Attempting to edit crystal: ${crystal.chemicalName ?? crystal.codId}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Crystals'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadSavedCrystals, // Disable if already loading
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                )
              : _savedCrystals.isEmpty
                  ? const Center(
                      child: Text(
                        'No crystals saved yet. Save some from the search page!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _savedCrystals.length,
                      itemBuilder: (context, index) {
                        final crystal = _savedCrystals[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Chemical Name: ${crystal.chemicalName ?? "N/A"}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text('COD ID: ${crystal.codId}'),
                                if (crystal.mineral != null && crystal.mineral!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text('Mineral: ${crystal.mineral}'),
                                ],
                                // Display new user-editable fields
                                const SizedBox(height: 8),
                                const Text('User Notes:', style: TextStyle(fontWeight: FontWeight.w600)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Crystal System: ${crystal.crystalSystem ?? 'Not set'}'),
                                      Text('Solubility: ${crystal.solubility ?? 'Not set'}'),
                                      Text('Cleavage Planes: ${crystal.cleavagePlanes ?? 'Not set'}'),
                                      Text('Appearance: ${crystal.appearance ?? 'Not set'}'),
                                      Text('Laue Exposure Time: ${crystal.laueExposureTime != null ? '${crystal.laueExposureTime} units' : 'Not set'}'),
                                    ],
                                  ),
                                ),
                                // Action buttons: Edit and Delete
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => _editCrystal(crystal),
                                      icon: const Icon(Icons.edit, size: 20),
                                      label: const Text('Edit'),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () => _deleteCrystal(crystal.codId),
                                      icon: const Icon(Icons.delete, size: 20),
                                      label: const Text('Delete'),
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}