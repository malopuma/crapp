// lib/main.dart

// crap short crystal app
// version 1.0.0
// may 18 2025

import 'package:flutter/material.dart';
import 'package:coda/pages/home.dart';
import 'package:coda/pages/hkl_hkil.dart';
import 'package:coda/pages/cod_search_page.dart';

void main() => runApp(MaterialApp(
  
  routes: {
    '/': (context) => Home(),
    '/CodSearch': (context) => CodSearchPage(),
    '/HKL_HKIL': (context) => HKL_HKIL(),
  },

));