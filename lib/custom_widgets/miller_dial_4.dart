import 'package:flutter/material.dart';
import 'package:coda/themes/app_theme_dark.dart';

class MillerDial4 extends StatefulWidget {
  final Function(int) onValueChangeH;
  final Function(int) onValueChangeK;
  final Function(int) onValueChangeI;
  final Function(int) onValueChangeL;

  const MillerDial4({
    super.key,
    required this.onValueChangeH,
    required this.onValueChangeK,
    required this.onValueChangeI,
    required this.onValueChangeL,
  });

  @override
  State<MillerDial4> createState() => _MillerDial3State();
}

class _MillerDial3State extends State<MillerDial4> {
  final AppThemeDark theme = AppThemeDark();

  int valueH = 0;
  int valueK = 0;
  int valueI = 0;
  int valueL = 0;
  bool hIsActive = true;
  bool kIsActive = false;


  Widget _buildDial(String label, int currentValue, Function(int) onChanged, bool isActive) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: <Widget>[
          
          // Column title
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.fontStyleWidgetText,
          ),

          SizedBox(height: 12),
      
          // Increase button
          Material(
            elevation: 12,
            borderRadius: BorderRadius.circular(24),
            color: WidgetStateColor.resolveWith((states) {
              if (isActive) {
                return theme.accentColor1.withValues(alpha: 0.2); 
              }
                return theme.appbackgroundColor;
              },),
            
            child: IconButton(
              onPressed: () {
                if (isActive) {
                  setState(() {
                    currentValue++;
                    onChanged(currentValue);
                  });
                }
              },
              icon: const Icon(Icons.arrow_upward_rounded),
              iconSize: 32,
              color: WidgetStateColor.resolveWith((states) {
                if (isActive) {
                  return theme.accentColor1;                  
                }
                return theme.appforegroundColor;
                },
              ),
            ),
          ),
          
          SizedBox(height: 12),

          // Current value if the index

          label == 'i'
            ?Text(
              '$currentValue',
              textAlign: TextAlign.center,
              style: theme.fontStyleWidgetTextHiglight,
            )
            :Text(
              '$currentValue',
              textAlign: TextAlign.center,
              style: theme.fontStyleWidgetOutput,
            ),
          
          SizedBox(height: 12),

          // Decrease button
          Material(
            elevation: 12,
            borderRadius: BorderRadius.circular(24),
            color: WidgetStateColor.resolveWith((states) {
              if (isActive) {
                return theme.accentColor1.withValues(alpha: 0.2);
              }
                return theme.appbackgroundColor;
              },),
            
            child: IconButton(
              onPressed: () {
                if (isActive) {
                  setState(() {
                    currentValue--;
                    onChanged(currentValue);
                  });
                }
              },
              icon: const Icon(Icons.arrow_downward_rounded),
              iconSize: 32,
              color: WidgetStateColor.resolveWith((states) {
                if (isActive) {
                  return theme.accentColor1;
                }
                return theme.appforegroundColor;
                },
              ),

            ),

          ),

        ],

      ),

    );

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.appforegroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('hkil input',
                style: theme.fontStyleWidgetNote,
                ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start, // Distribute dials horizontally
            children: <Widget>[
              
              //h-column
              //--------------------
              Column(
                children: [
                
                  _buildDial(
                    'h',
                    valueH,
                    (newValue) {
                      setState(() {
                        valueH = newValue;
                        valueI = (valueH + valueK) * -1;
                        widget.onValueChangeH(newValue);
                        widget.onValueChangeI(valueI);
                      });
                    },
                    hIsActive
                  ),

                  SizedBox(height: 6),
                
                  // Button thas fixes the h-row
                  // Swappes color dependindg on isFixed 
                  Material(
                    elevation: 12,
                    borderRadius: BorderRadius.circular(24),
                    color: WidgetStateColor.resolveWith((states) {
                      if (hIsActive) {
                        return theme.accentColor1.withValues(alpha: 0.2);
                      }
                      return theme.appbackgroundColor;
                    },),
                    
                    child: IconButton(
                      onPressed: () {
                        if (!hIsActive) {
                          setState(() {
                            hIsActive = !hIsActive;
                            kIsActive = !kIsActive;
                            //print('hk fix state: hIsFixed = $hIsFixed, kIsFixed = $kIsFixed');
                          });
                        }
                      },
                      icon: Icon(Icons.adjust),
                      iconSize: 32,
                      color: WidgetStateColor.resolveWith((states) {
                        if (hIsActive) {
                          return theme.accentColor1;
                        }
                        return theme.appforegroundColor;
                        },
                      ),
                    )

                  ),

                  SizedBox(height: 6),

                ],
              ),
              

              //k-Column
              //--------------------
              Column(
                children: [
                
                  _buildDial(
                    'k',
                    valueK,
                    (newValue) {
                      setState(() {
                        valueK = newValue;
                        valueI = (valueH + valueK) * -1;
                        widget.onValueChangeK(newValue);
                        widget.onValueChangeI(valueI);
                      });
                    },
                    kIsActive
                  ),
                  
                  SizedBox(height: 6),

                  // Button thas fixes the k-row //
                  // Swappes color dependindg on isFixed 
                  Material(
                    elevation: 12,
                    borderRadius: BorderRadius.circular(24),
                    color: WidgetStateColor.resolveWith((states) {
                      if (kIsActive) {
                        return theme.accentColor1.withValues(alpha: 0.2);
                      }
                      return theme.appbackgroundColor;
                    },),

                    child: IconButton(
                      onPressed: () {
                        if (!kIsActive) {
                          setState(() {
                            hIsActive = !hIsActive;
                            kIsActive = !kIsActive;
                          });
                        }
                      },
                      icon: Icon(Icons.adjust),
                      iconSize: 32,
                      color: WidgetStateColor.resolveWith((states) {
                        if (kIsActive) {
                          return theme.accentColor1;
                        }
                        return theme.appforegroundColor;
                        },
                      ),
                    )
                  )

              ]),
              
              //i-Column
              //--------------------
              _buildDial(
                'i',
                valueI,
                (newValue)
                {
                  setState(() {
                    valueI = newValue;
                    if (kIsActive) {
                      valueK = (-valueI-valueH);
                    }
                    else {
                      valueH = (-valueI-valueK);
                    }
                    widget.onValueChangeI(newValue);
                    widget.onValueChangeH(valueH);
                    widget.onValueChangeK(valueK);
                  });
                },
                true
              ),
              
              //l-Column
              //--------------------
              _buildDial(
                'l',
                valueL,
                (newValue) {
                  setState(() {
                    valueL = newValue;
                    widget.onValueChangeL(newValue);
                  });
                },
                true
              ),
            
            ],
          ),
        ],
      ),
    );
  }
}