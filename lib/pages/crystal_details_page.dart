// lib/pages/crystal_details_page.dart

import 'package:flutter/material.dart';
import 'package:coda/db_stuff/crystal_info.dart';
import 'package:coda/db_stuff/database_helper.dart'; // To perform delete/update
import 'package:coda/pages/edit_crystal_page.dart'; // To navigate to edit page

class CrystalDetailsPage extends StatefulWidget {
  final CrystalInfo crystal;

  const CrystalDetailsPage({super.key, required this.crystal});

  @override
  State<CrystalDetailsPage> createState() => _CrystalDetailsPageState();
}

class _CrystalDetailsPageState extends State<CrystalDetailsPage> {
  // We'll manage the crystal object's state here to reflect updates
  late CrystalInfo _currentCrystal;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _currentCrystal = widget.crystal; // Initialize with the passed crystal
  }

  // Function to handle editing
  Future<void> _editCrystal() async {
    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCrystalPage(crystal: _currentCrystal),
      ),
    );

    // If result is true, an update occurred, so reload this crystal's details
    if (result == true) {
      // Fetch the updated crystal from the database
      final updatedCrystal = await _dbHelper.getCrystalInfoById(_currentCrystal.codId);
      if (updatedCrystal != null) {
        setState(() {
          _currentCrystal = updatedCrystal; // Update the state with new data
        });
        // Indicate to the previous page (SavedCrystalsPage) that data changed
        // This is crucial for SavedCrystalsPage to refresh if we navigated back
        Navigator.pop(context, true); // Pop this page, signaling a change
      }
    }
  }

  // Function to handle deletion
  Future<void> _deleteCrystal() async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "${_currentCrystal.chemicalName ?? _currentCrystal.codId}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false), // User cancels
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true), // User confirms
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await _dbHelper.deleteCrystalInfo(_currentCrystal.codId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Crystal "${_currentCrystal.chemicalName ?? _currentCrystal.codId}" deleted.')),
        );
        // Navigate back to SavedCrystalsPage and indicate deletion
        Navigator.pop(context, true); // Pop this page, signaling a change
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete crystal: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentCrystal.chemicalName ?? 'Crystal Details'),
        actions: [
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editCrystal,
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteCrystal,
          ),
        ],
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView to prevent overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display COD-fetched data
            _buildInfoRow('COD ID:', _currentCrystal.codId),
            _buildInfoRow('Chemical Name:', _currentCrystal.chemicalName),
            _buildInfoRow('Mineral:', _currentCrystal.mineral),
            _buildInfoRow('Space Group:', _currentCrystal.spaceGroup),
            _buildInfoRow('Title:', _currentCrystal.title),
            _buildInfoRow('DOI:', _currentCrystal.doi),
            _buildInfoRow('Year:', _currentCrystal.year),

            const Divider(height: 32, thickness: 1),

            // Cell Parameters Section
            Text('Cell Parameters:', style: Theme.of(context).textTheme.titleMedium),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('a:', _currentCrystal.a, suffix: ' Å'),
                  _buildInfoRow('b:', _currentCrystal.b, suffix: ' Å'),
                  _buildInfoRow('c:', _currentCrystal.c, suffix: ' Å'),
                  _buildInfoRow('alpha:', _currentCrystal.alpha, suffix: '°'),
                  _buildInfoRow('beta:', _currentCrystal.beta, suffix: '°'),
                  _buildInfoRow('gamma:', _currentCrystal.gamma, suffix: '°'),
                ],
              ),
            ),

            const Divider(height: 32, thickness: 1),

            // User-editable fields
            Text('User Notes:', style: Theme.of(context).textTheme.titleMedium),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Crystal System:', _currentCrystal.crystalSystem),
                  _buildInfoRow('Solubility:', _currentCrystal.solubility),
                  _buildInfoRow('Cleavage Planes:', _currentCrystal.cleavagePlanes),
                  _buildInfoRow('Appearance:', _currentCrystal.appearance),
                  _buildInfoRow('Laue Exposure Time:', _currentCrystal.laueExposureTime?.toString(), suffix: ' units'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build consistent info rows
  Widget _buildInfoRow(String label, String? value, {String suffix = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130, // Adjust width as needed for alignment
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              '${value ?? 'Not set'} $suffix',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}