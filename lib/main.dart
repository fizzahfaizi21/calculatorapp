import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _displayText = "0";
  bool _isNewInput = true;
  String _firstOperand = "";
  String _operator = "";

  void _onNumberPressed(String number) {
    setState(() {
      if (_isNewInput || _displayText == "0") {
        _displayText = number;
        _isNewInput = false;
      } else {
        _displayText += number;
      }
    });
  }

  void _onOperatorPressed(String operator) {
    // Save the first operand and the operator
    if (_displayText != "0" && !_isNewInput) {
      _firstOperand = _displayText;
      _operator = operator;
      _isNewInput = true;
    }
  }

  void _onEqualsPressed() {
    if (_firstOperand.isNotEmpty && _operator.isNotEmpty && !_isNewInput) {
      double result = 0;
      double num1 = double.parse(_firstOperand);
      double num2 = double.parse(_displayText);

      switch (_operator) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          if (num2 != 0) {
            result = num1 / num2;
          } else {
            // Handle division by zero
            setState(() {
              _displayText = "Error";
              _isNewInput = true;
              _firstOperand = "";
              _operator = "";
            });
            return;
          }
          break;
      }

      setState(() {
        // Format the result to remove decimal if it's a whole number
        if (result == result.roundToDouble()) {
          _displayText = result.toInt().toString();
        } else {
          _displayText = result.toString();
        }
        _isNewInput = true;
        _firstOperand = "";
        _operator = "";
      });
    }
  }

  void _onButtonPressed(String buttonText) {
    if (buttonText == '=') {
      _onEqualsPressed();
    } else if (buttonText == '+' ||
        buttonText == '-' ||
        buttonText == '*' ||
        buttonText == '/') {
      _onOperatorPressed(buttonText);
    } else if (buttonText == '.') {
      if (!_displayText.contains('.')) {
        setState(() {
          if (_isNewInput) {
            _displayText = "0.";
            _isNewInput = false;
          } else {
            _displayText += '.';
          }
        });
      }
    } else {
      _onNumberPressed(buttonText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
      ),
      body: Column(
        children: [
          // Display Area
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Text(
              _displayText,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Display the current operation
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _firstOperand.isNotEmpty ? "$_firstOperand $_operator" : "",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
          ),
          Divider(),
          // Calculator Buttons
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  buildButtonRow(['7', '8', '9', '/']),
                  buildButtonRow(['4', '5', '6', '*']),
                  buildButtonRow(['1', '2', '3', '-']),
                  buildButtonRow(['0', '.', '=', '+']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((button) => buildButton(button)).toList(),
      ),
    );
  }

  Widget buildButton(String text) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(24),
            backgroundColor: text == '='
                ? Colors.orange
                : (text == '+' || text == '-' || text == '*' || text == '/')
                    ? Colors.purple
                    : Colors.blue,
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color:
                  Colors.white, // Changed text color to white for all buttons
            ),
          ),
        ),
      ),
    );
  }
}
