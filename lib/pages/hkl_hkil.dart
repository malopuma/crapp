import 'package:coda/custom_widgets/miller_dial_4.dart';
import 'package:flutter/material.dart';
import 'package:coda/themes/app_theme_dark.dart';

class HKL_HKIL extends StatefulWidget {
  const HKL_HKIL({super.key});

  @override
  State<HKL_HKIL> createState() => _HKL_HKILState();
}

class _HKL_HKILState extends State<HKL_HKIL> {
  
  final AppThemeDark theme = AppThemeDark();

  int valueH = 0;
  int valueK = 0;
  int valueI = 0;
  int valueL = 0;
  
  void setValueH(int newValue){
    setState(() {
      valueH = newValue; 
      valueI = (valueH + valueK) * -1;
    });
  }

  void setValueK(int newValue){
    setState(() {
      valueK = newValue;
      valueI = (valueH + valueK) * -1;
    });
  }

  void setValueI(int newValue){
    setState(() {}
    );
  }

  void setValueL(int newValue){
    setState(() {
      valueL = newValue;  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: theme.accentColor1,
        title: Text('find HKIL'),
      ),
      
      backgroundColor: theme.appbackgroundColor,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: <Widget>[

          Row(
            children: [
              Expanded(child: MillerDial4(onValueChangeH: setValueH, onValueChangeK: setValueK, onValueChangeI: setValueI, onValueChangeL: setValueL,))
            ],)

        ],
      )
    );
  }
}