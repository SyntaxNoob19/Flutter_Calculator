
import 'package:calculatorapp/colors.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  var input = '';
  var output = '';
  var hideInput = false;
  var outputSize = 20.0;

  onButtonClicked(value) {
    if (value == 'C') {
      input = '';
      output = '';
    } else if (value == '⌫') {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    } else if (value == '=') {
      if (input.isNotEmpty) {
        // Remove the last character if it's an operator
        while (input.isNotEmpty && '+-×÷'.contains(input[input.length - 1])) {
          input = input.substring(0, input.length - 1);
        }
      }

      if (input.isNotEmpty) {
        try {
           // Handle percentage for addition and subtraction
      String userInput = input.replaceAllMapped(
        RegExp(r'(\d+(\.\d+)?)([+\-])(\d+(\.\d+)?)%'), 
        (match) {
          double base = double.parse(match.group(1)!);
          double percent = double.parse(match.group(4)!);
          double calculatedPercent = base * percent / 100;
          return '${match.group(1)}${match.group(3)}$calculatedPercent';
        },
      );

      // Handle percentage for multiplication and division
      userInput = userInput.replaceAllMapped(
        RegExp(r'(\d+(\.\d+)?)([×÷])(\d+(\.\d+)?)%'), 
        (match) {
          double percent = double.parse(match.group(4)!);
          double decimal = percent / 100;
          return '${match.group(1)}${match.group(3)}$decimal';
        },
      );

      userInput = userInput.replaceAllMapped(
        RegExp(r'(\d+(\.\d+)?)%'),
        (match) {
          double percent = double.parse(match.group(1)!);
          return (percent / 100).toString();
        },
      );

           userInput = userInput.replaceAll('÷', '/').replaceAll('×', '*');

          Parser p = Parser();
          Expression expression = p.parse(userInput);
          ContextModel cm = ContextModel();
          var finalValue = expression.evaluate(EvaluationType.REAL, cm);
          output = finalValue.toString();

          // Check for Infinity or NaN
          if (finalValue.isInfinite || finalValue.isNaN) {
            output = 'Error';
          } else {
            //Check if output end with .0  
            output = finalValue.toString();
            if (output.endsWith('.0')) {
              output = output.substring(0, output.length - 2);
            }
          }
        } catch (e) {
          output = 'Error';
        }
        input = output;
        hideInput = true;
        outputSize = 35;
      }
    } else {
      // Prevent the input from starting with an operator like '+', '×', or '÷'.
      if (input.isEmpty && (value == '+' || value == '×' || value == '÷')) {
        return;
      }

      if (input.isNotEmpty) {
        String lastchar = input[input.length - 1];

        // Prevent entering two consecutive operators like '++', '×+', '÷×', etc.
        if ('+-×÷'.contains(lastchar) && '+×÷'.contains(value)) {
          return;
        }

        // Prevent entering two consecutive '-' operators (like '--').
        if (lastchar == '-' && value == '-') {
          return;
        }
      }

      // Prevent starting with '.'
      if (input.isEmpty && value == '.') {
        input = '0.';
        setState(() {});
        return;
      }

      // Prevent multiple decimal points in a number
      if (value == '.') {
        var parts = input.split(RegExp(r'[+\-×÷]'));
        if (parts.isNotEmpty && parts.last.contains('.')) {
          return;
        }
      }

      input += value;
      hideInput = false;
      outputSize = 25;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hideInput ? '' : input,
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  output,
                  style: TextStyle(
                    fontSize: outputSize,
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )),
          Row(
            children: [
              button(
                  text: 'C',
                  textColor: calculateColor,
                  buttonBgColor: operatorColor),
              button(
                  text: '⌫',
                  textColor: calculateColor,
                  buttonBgColor: operatorColor),
              button(text: '%', buttonBgColor: operatorColor),
              button(text: '÷', buttonBgColor: operatorColor)
            ],
          ),
          Row(
            children: [
              button(
                text: '7',
              ),
              button(
                text: '8',
              ),
              button(
                text: '9',
              ),
              button(text: '×', buttonBgColor: operatorColor)
            ],
          ),
          Row(
            children: [
              button(
                text: '4',
              ),
              button(
                text: '5',
              ),
              button(
                text: '6',
              ),
              button(text: '-', buttonBgColor: operatorColor)
            ],
          ),
          Row(
            children: [
              button(
                text: '1',
              ),
              button(
                text: '2',
              ),
              button(
                text: '3',
              ),
              button(text: '+', buttonBgColor: operatorColor)
            ],
          ),
          Row(
            children: [
              button(
                text: '00',
              ),
              button(
                text: '0',
              ),
              button(
                text: '.',
              ),
              button(text: '=', buttonBgColor: calculateColor)
            ],
          ),
        ],
      ),
    );
  }

  Widget button({text, textColor = Colors.white, buttonBgColor = buttonColor}) {
    return Expanded(
        child: Container(
            margin: EdgeInsets.all(10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBgColor,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  onButtonClicked(text);
                },
                child: Text(text,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor)))));
  }
}
