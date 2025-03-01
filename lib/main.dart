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
  bool _hasError = false;

  void _clear() {
    setState(() {
      _displayText = "0";
      _isNewInput = true;
      _firstOperand = "";
      _operator = "";
      _hasError = false;
    });
  }

  void _onNumberPressed(String number) {
    if (_hasError) {
      _clear();
    }

    setState(() {
      if (_isNewInput || _displayText == "0") {
        _displayText = number;
        _isNewInput = false;
      } else {
        // Prevent numbers from getting too long
        if (_displayText.length < 10) {
          _displayText += number;
        }
      }
    });
  }

  void _onOperatorPressed(String operator) {
    if (_hasError) {
      _clear();
      return;
    }

    // If an operation is in progress, calculate the result first
    if (_firstOperand.isNotEmpty && _operator.isNotEmpty && !_isNewInput) {
      _onEqualsPressed();
      if (_hasError) return;
    }

    // Save the first operand and the operator
    setState(() {
      _firstOperand = _displayText;
      _operator = operator;
      _isNewInput = true;
    });
  }

  void _onEqualsPressed() {
    if (_hasError) {
      _clear();
      return;
    }

    if (_firstOperand.isNotEmpty && _operator.isNotEmpty && !_isNewInput) {
      double result = 0;
      double num1 = double.parse(_firstOperand);
      double num2 = double.parse(_displayText);

      try {
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
            if (num2 == 0) {
              // Return 0 for division by zero instead of throwing an error
              result = 0;
            } else {
              result = num1 / num2;
            }
            break;
        }

        setState(() {
          // Format the result to remove decimal if it's a whole number
          if (result == result.roundToDouble()) {
            _displayText = result.toInt().toString();
          } else {
            // Limit decimal places to keep the display clean
            _displayText = result
                .toStringAsFixed(8)
                .replaceAll(RegExp(r'0+$'), '')
                .replaceAll(RegExp(r'\.$'), '');
          }

          // Handle very large or small numbers
          if (double.parse(_displayText).abs() > 999999999 ||
              (double.parse(_displayText).abs() < 0.000001 &&
                  double.parse(_displayText) != 0)) {
            _displayText = result.toStringAsExponential(4);
          }

          _isNewInput = true;
          _firstOperand = "";
          _operator = "";
        });
      } catch (e) {
        setState(() {
          _displayText = "Error";
          _hasError = true;
          _isNewInput = true;
          _firstOperand = "";
          _operator = "";
        });
      }
    }
  }

  void _onButtonPressed(String buttonText) {
    if (buttonText == 'C') {
      _clear();
    } else if (buttonText == '=') {
      _onEqualsPressed();
    } else if (buttonText == '+' ||
        buttonText == '-' ||
        buttonText == '*' ||
        buttonText == '/') {
      _onOperatorPressed(buttonText);
    } else if (buttonText == '.') {
      if (_hasError) {
        _clear();
      }

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
                color: _hasError ? Colors.red : Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
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
                  buildButtonRow(['C']),
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
        children: buttons.map((button) {
          // Handle the Clear button differently, making it span the whole row
          if (button == 'C' && buttons.length == 1) {
            return Expanded(child: buildButton(button));
          }
          return Expanded(child: buildButton(button));
        }).toList(),
      ),
    );
  }

  Widget buildButton(String text) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(24),
          backgroundColor: text == 'C'
              ? Colors.red
              : text == '='
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
            color: Colors.white, // Changed text color to white for all buttons
          ),
        ),
      ),
    );
  }
}
