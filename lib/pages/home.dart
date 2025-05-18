// lib/pages/home.dart
// this page will be displayed first

import 'package:flutter/material.dart';
import 'package:coda/themes/app_theme_dark.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

AppThemeDark theme = AppThemeDark();

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Crapp'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          SizedBox(height: 6,),
      
          Container(
            padding: EdgeInsets.all(6),
            child: FloatingActionButton(
              heroTag: null,                
              onPressed: () {Navigator.pushNamed(context, '/HKL_HKIL');},
              child: Text('HKL / HKIL'),
            ),
          ),
      
          Container(
            padding: EdgeInsets.all(6),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {Navigator.pushNamed(context, '/CodSearch');},
              child: Text('COD search'),
            ),
          ),
          
        ],

      )

    );

  }

}