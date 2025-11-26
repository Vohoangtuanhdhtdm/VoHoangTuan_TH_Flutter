import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/widgets/calculator_button.dart';
import 'package:math_expressions/math_expressions.dart';

final List<List<String>> keys = [
  ['C', '()', '%', '÷'],
  ['7', '8', '9', '×'],
  ['4', '5', '6', '-'],
  ['1', '2', '3', '+'],
  ['+/-', '0', '.', '='],
];

Color getButtonColor(String label) {
  if (label == 'C') return const Color(0xFFB04949);
  if (label == '=') return const Color(0xFF0F6C44);
  if (['÷', '×', '-', '+'].contains(label)) return const Color(0xFF2E4F3E);
  return const Color(0xFF333333);
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '0';

  void _onButtonPressed(String label) {
    setState(() {
      if (label == 'C') {
        _result = '0';
        _expression = '';
        return;
      }

      if (label == '=') {
        _calculateResult();
        return;
      }
      if (label == '+/-') {
        _toggleSign();
        return;
      }
      if (label == '%') {
        _applyPercent();
        return;
      }
      if (label == '()') {
        _addParentheses();
        return;
      }
      _expression += label; // nối thêm text
    });
  }

  void _applyPercent() {
    if (_expression.isEmpty) return;

    double? value = double.tryParse(_expression);
    if (value != null) {
      value = value / 100;
      _expression = value.toString();
    } else {}
  }

  void _addParentheses() {
    int openCount = '('.allMatches(_expression).length;
    int closeCount = ')'.allMatches(_expression).length;

    if (openCount == closeCount) {
      _expression += '(';
    } else {
      _expression += ')';
    }
  }

  void _calculateResult() {
    if (_expression.isEmpty) return;

    try {
      String exp = _expression.replaceAll('×', '*').replaceAll('÷', '/');

      Parser parser = Parser();
      Expression expression = parser.parse(exp);
      ContextModel cm = ContextModel();

      double eval = expression.evaluate(EvaluationType.REAL, cm);

      if (eval % 1 == 0) {
        _result = eval.toInt().toString();
      } else {
        _result = eval.toString();
      }
    } catch (e) {
      _result = 'Error';
    }
  }

  void _toggleSign() {
    if (_expression.isEmpty) return;

    if (double.tryParse(_expression) != null) {
      if (_expression.startsWith('-')) {
        _expression = _expression.substring(1);
      } else {
        _expression = '-$_expression';
      }
      return;
    }

    if (double.tryParse(_result) != null) {
      double value = double.parse(_result) * -1;
      _expression = value.toString();
      _result = value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Vùng hiển thị
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression.isEmpty ? '' : _expression,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bàn phím
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                children: keys.map((row) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: row.map((label) {
                      return CalculatorButton(
                        label: label,
                        background: getButtonColor(label),
                        onTap: () => _onButtonPressed(label),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
