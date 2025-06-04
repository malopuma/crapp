// lib/pages/saved_crystals_page.dart

import 'package:flutter/material.dart';
import 'package:coda/db_stuff/crystal_info.dart';
import 'package:coda/db_stuff/database_helper.dart';
//import 'package:coda/pages/edit_crystal_page.dart';
// NEW: Import the CrystalDetailsPage (we'll create this next)
import 'package:coda/pages/crystal_details_page.dart'; // Adjust path if needed

class SavedCrystalsPage extends StatefulWidget {
  const SavedCrystalsPage({super.key});

  @override
  State<SavedCrystalsPage> createState() => _SavedCrystalsPageState();
}

class _SavedCrystalsPageState extends State<SavedCrystalsPage> {
  List<CrystalInfo> _savedCrystals = [];
  bool _isLoading = true;
  String? _errorMessage;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSavedCrystals();
  }

  Future<void> _loadSavedCrystals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final crystals = await _dbHelper.getCrystalInfoList();
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

  // NOTE: _deleteCrystal and _editCrystal will be called from CrystalDetailsPage now
  // but we'll keep them here for now, or you could pass this function to the details page.
  // For simplicity and direct action, let's move the actual calls to _deleteCrystal
  // and _editCrystal to be part of the _dbHelper in the details page, or passed as callbacks.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Crystals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadSavedCrystals,
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
                          // NEW: Make the card tappable
                          child: InkWell( // InkWell provides visual feedback on tap
                            onTap: () async {
                              // Navigate to CrystalDetailsPage and pass the crystal
                              final bool? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CrystalDetailsPage(crystal: crystal),
                                ),
                              );
                              // If details page indicates a change (edit/delete), refresh the list
                              if (result == true) {
                                _loadSavedCrystals();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${crystal.chemicalName ?? "N/A"}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('COD ID: ${crystal.codId}'),
                                  if (crystal.spaceGroup != null && crystal.spaceGroup!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text('Space Group: ${crystal.spaceGroup}'),
                                  ],
                                  // Removed detailed display and buttons from here
                                  // These will now be on CrystalDetailsPage
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}