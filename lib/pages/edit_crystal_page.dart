// lib/pages/edit_crystal_page.dart

import 'package:flutter/material.dart';
import 'package:coda/db_stuff/crystal_info.dart'; // Your CrystalInfo class
import 'package:coda/db_stuff/database_helper.dart'; // Your DatabaseHelper

class EditCrystalPage extends StatefulWidget {
  final CrystalInfo crystal; // The crystal object passed from SavedCrystalsPage

  const EditCrystalPage({super.key, required this.crystal});

  @override
  State<EditCrystalPage> createState() => _EditCrystalPageState();
}

class _EditCrystalPageState extends State<EditCrystalPage> {
  // Controllers for the new user-editable text fields
  // Initialize them with existing crystal data or empty string
  final TextEditingController _crystalSystemController = TextEditingController();
  final TextEditingController _solubilityController = TextEditingController();
  final TextEditingController _cleavagePlanesController = TextEditingController();
  final TextEditingController _appearanceController = TextEditingController();
  final TextEditingController _laueExposureTimeController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper(); // Database Helper instance

  @override
  void initState() {
    super.initState();
    // Populate controllers with existing data when the page loads
    _crystalSystemController.text = widget.crystal.crystalSystem ?? '';
    _solubilityController.text = widget.crystal.solubility ?? '';
    _cleavagePlanesController.text = widget.crystal.cleavagePlanes ?? '';
    _appearanceController.text = widget.crystal.appearance ?? '';
    _laueExposureTimeController.text = widget.crystal.laueExposureTime?.toString() ?? '';
  }

  // Function to save the updated crystal info
  Future<void> _saveChanges() async {
    // Create a new CrystalInfo object with updated editable fields
    // We create a *new* object because the original fields (codId, chemicalName, etc.) are final
    // and cannot be modified. Only the non-final user-editable fields will change.
    final updatedCrystal = CrystalInfo(
      codId: widget.crystal.codId,
      chemicalName: widget.crystal.chemicalName,
      mineral: widget.crystal.mineral,
      spaceGroup: widget.crystal.spaceGroup,
      a: widget.crystal.a,
      b: widget.crystal.b,
      c: widget.crystal.c,
      alpha: widget.crystal.alpha,
      beta: widget.crystal.beta,
      gamma: widget.crystal.gamma,
      title: widget.crystal.title,
      doi: widget.crystal.doi,
      year: widget.crystal.year,
      // Update the user-editable fields from controllers
      crystalSystem: _crystalSystemController.text.isNotEmpty ? _crystalSystemController.text : null,
      solubility: _solubilityController.text.isNotEmpty ? _solubilityController.text : null,
      cleavagePlanes: _cleavagePlanesController.text.isNotEmpty ? _cleavagePlanesController.text : null,
      appearance: _appearanceController.text.isNotEmpty ? _appearanceController.text : null,
      // Convert Laue Exposure Time to double
      laueExposureTime: double.tryParse(_laueExposureTimeController.text),
    );

    try {
      await _dbHelper.updateCrystalInfo(updatedCrystal); // Call the update method
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Crystal "${updatedCrystal.chemicalName ?? updatedCrystal.codId}" updated successfully!')),
      );
      // Navigate back to the previous page (SavedCrystalsPage)
      // Pass 'true' to indicate that a change was made and the previous page should refresh
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update crystal: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _crystalSystemController.dispose();
    _solubilityController.dispose();
    _cleavagePlanesController.dispose();
    _appearanceController.dispose();
    _laueExposureTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We can also display the uneditable COD data for context
    final crystal = widget.crystal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Crystal Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView( // Use ListView for scrolling if content overflows
          children: <Widget>[
            // Display some of the fixed COD data for context
            Text('COD ID: ${crystal.codId}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Chemical Name: ${crystal.chemicalName ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            Text('Space Group: ${crystal.spaceGroup ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            const Divider(height: 32, thickness: 1),

            // User-editable fields
            _buildTextField(_crystalSystemController, 'Crystal System'),
            _buildTextField(_solubilityController, 'Solubility'),
            _buildTextField(_cleavagePlanesController, 'Cleavage Planes'),
            _buildTextField(_appearanceController, 'Appearance'),
            _buildTextField(_laueExposureTimeController, 'Laue Exposure Time (units)', keyboardType: TextInputType.number), // For numbers

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a TextFormField
  Widget _buildTextField(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          // Optional: Add a clear button
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => controller.clear(),
          ),
        ),
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next, // Go to next field on "Done"
      ),
    );
  }
}