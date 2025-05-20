// lib/cod_search_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:coda/db_stuff/crystal_info.dart';
import 'package:coda/db_stuff/database_helper.dart';

class CodSearchPage extends StatefulWidget {
  const CodSearchPage({super.key});

  @override
  State<CodSearchPage> createState() => _CodSearchPageState();
}

class _CodSearchPageState extends State<CodSearchPage> {
  final TextEditingController _formulaController = TextEditingController();

  List<CrystalInfo> _crystalResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQueryInfo = "Please enter a chemical formula and press search. The entered material will be searched in the Crystal Open Database.";

  // Instance of the DatabaseHelper
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _fetchCrystalData(String chemicalFormula) async {
    if (chemicalFormula.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a chemical formula.";
        _crystalResults = [];
        _isLoading = false;
        _searchQueryInfo = "Search results will appear here.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _crystalResults = [];
      _searchQueryInfo = "Searching for: $chemicalFormula...";
    });

    RegExp splitElements = RegExp(r'(?=[A-Z])');
    List<String> elements = chemicalFormula.split(splitElements);
    elements.sort();

    final elementBuffer = StringBuffer();
    for (String element in elements) {
      elementBuffer.write(element);
      elementBuffer.write('%20');
    }

    String cutLastThreeLetters(String inputString) {
      if (inputString.length >= 3) {
        String formattedFormula = inputString.substring(0, inputString.length - 3);
        return formattedFormula;
      } else {
        return 'formattedFormula() failed';
      }
    }

    String formattedFormula = cutLastThreeLetters(elementBuffer.toString());

    var url = Uri.parse('https://www.crystallography.net/cod/result?formula=$formattedFormula&format=json');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<CrystalInfo> tempList = [];
        for (var itemJson in jsonData) {
          if (itemJson is Map<String, dynamic>) {
            tempList.add(CrystalInfo.fromJson(itemJson));
          }
        }
        setState(() {
          _crystalResults = tempList;
          _isLoading = false;
          if (tempList.isEmpty) {
            _searchQueryInfo = "No results found for '$chemicalFormula'.";
          } else {
            _searchQueryInfo = "Showing ${tempList.length} results for '$chemicalFormula'.";
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data. Status code: ${response.statusCode}\nResponse: ${response.body}';
          _isLoading = false;
          _searchQueryInfo = "Error fetching data for '$chemicalFormula'.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
        _searchQueryInfo = "Error occurred during search for '$chemicalFormula'.";
      });
    }
  }

  // Function to save CrystalInfo to the database
  Future<void> _saveCrystalInfo(CrystalInfo crystalInfo) async {
    try {
      await _dbHelper.insertCrystalInfo(crystalInfo);
      // Show a SnackBar to confirm saving
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved "${crystalInfo.chemicalName ?? crystalInfo.codId}" to local database!'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show an error SnackBar if saving fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save crystal: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _formulaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crystal COD Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _formulaController,
              decoration: const InputDecoration(
                labelText: 'Chemical Formula',
                hintText: 'e.g.NaCl',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _fetchCrystalData(value);
                }
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : () {
                _fetchCrystalData(_formulaController.text);
              },
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    )
                  : const Text('Search'),
            ),
            const SizedBox(height: 24.0),
            Text(_searchQueryInfo, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8.0),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: _crystalResults.isEmpty && !_isLoading && _errorMessage == null
                  ? Center(
                      child: Text(
                        _formulaController.text.isEmpty && _crystalResults.isEmpty
                            ? ""
                            : "No results to display.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _crystalResults.length,
                      itemBuilder: (context, index) {
                        final crystal = _crystalResults[index];
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
                                if (crystal.title != null && crystal.title!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text('Publication Title: ${crystal.title}'),
                                ],
                                if (crystal.year != null && crystal.year!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text('Year: ${crystal.year}'),
                                ],
                                if (crystal.doi != null && crystal.doi!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text('DOI: ${crystal.doi}'),
                                ],
                                if (crystal.spaceGroup != null && crystal.spaceGroup!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Space Group: ${crystal.spaceGroup}',
                                    style: const TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                const Text('Cell Parameters:', style: TextStyle(fontWeight: FontWeight.w500)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('a: ${crystal.a ?? "N/A"}  \talpha: ${crystal.alpha ?? "N/A"}°'),
                                      Text('b: ${crystal.b ?? "N/A"}  \tbeta: ${crystal.beta ?? "N/A"}°'),
                                      Text('c: ${crystal.c ?? "N/A"}  \tgamma: ${crystal.gamma ?? "N/A"}°'),
                                    ],
                                  ),
                                ),
                                // NEW: Save button for each crystal
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _saveCrystalInfo(crystal),
                                    icon: const Icon(Icons.save),
                                    label: const Text('Save Crystal'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}