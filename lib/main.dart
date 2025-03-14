
import 'package:calculatorapp/calculator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// IMPLEMENT

// FLEX CONTAINER HAVE 30/40 AND REMAINING TO 70/60

// no two operator can be used simultaneously except first one is %
// History
// as soon inter input output should be shown immediately // without pressing = show output ----- rel time evaluation or Live Evaluation
//10%10%       10%-10%     10%%    10%/10%


// symbol ⌫ ÷ x
//Parsing the Expression,Context for Variables 
//in this calculator this allows me to press */+- operator at first  place but it should only allow - operrator as negation
// can not click same operator at a time ++ 
// no two operator can be used simultaneously  except - for showing negation
//The current condition would still allow multiple consecutive - signs (like 6----6), which isn't valid.
// Prevent starting with '.'
// Prevent multiple decimal points in a number
// if number is divided by 0 
//Ending with an Operator and Pressing =
// % operator working




class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: CalculatorApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}
