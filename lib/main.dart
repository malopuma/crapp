// lib/main.dart
// github: malopuma/crapp

// crap short crystal app
// version 1.0.0
// may 18 2025

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:coda/pages/home.dart';
import 'package:coda/pages/hkl_hkil.dart';
import 'package:coda/pages/cod_search_page.dart';
import 'package:coda/pages/saved_crystals_page.dart'; // Corrected import name from 'saved_crystals' for consistency
import 'package:coda/db_stuff/database_helper.dart'; // Your DatabaseHelper import
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite_common_ffi for desktop/non-mobile platforms.
  // This has to be done because is does not initialize per default for desctop..
  if (TargetPlatform.windows == defaultTargetPlatform ||
      TargetPlatform.macOS == defaultTargetPlatform ||
      TargetPlatform.linux == defaultTargetPlatform) {
    
    // Initialize FFI for desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

  } else if (defaultTargetPlatform == TargetPlatform.android ||
             defaultTargetPlatform == TargetPlatform.iOS) {
    // On mobile, sqflite's default factory works out of the box. No special init needed.
  }

  // If you are targeting web:
  // else if (defaultTargetPlatform == TargetPlatform.fuchsia) { // Or specify TargetPlatform.web if available directly
  //   databaseFactory = databaseFactoryFfiWeb;
  // }


  // Initialize the database helper
  await DatabaseHelper().database;

  runApp(MaterialApp(
    routes: {
      '/': (context) => const Home(),
      '/HKL_HKIL': (context) => const HKL_HKIL(),
      '/CodSearch': (context) => const CodSearchPage(),
      '/SavedCrystals': (context) => const SavedCrystalsPage(),
    },
  ));
}