import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  static String calculate(String expression, {bool isDegree = false}) {
    if (expression.isEmpty) return '';
    try {
      //Chuyển ký tự cho math_expressions hiểu
      String finalExp = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', '3.1415926535')
          .replaceAll('e', '2.7182818284')
          .replaceAll('√', 'sqrt');

      finalExp = finalExp.replaceAllMapped(
        RegExp(r'(\d|\))(\(|π|e|sin|cos|tan|log|ln|sqrt)'),
        (Match m) => "${m[1]}*${m[2]}",
      );

      if (isDegree) {
        finalExp = finalExp.replaceAllMapped(
          RegExp(r'(sin|cos|tan)\(([^)]+)\)'),
          (Match m) => "${m[1]}((${m[2]}) * 0.01745329251)",
        );
      }

      Parser p = Parser();
      Expression exp = p.parse(finalExp);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Định dạng kết quả
      if (eval.isNaN) return "Error";
      if (eval.isInfinite) return "Infinite";

      if (eval % 1 == 0) {
        return eval.toInt().toString();
      }
      return eval.toStringAsFixed(8).replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
    } catch (e) {
      return 'Error';
    }
  }

  static String toggleSign(String currentExpr) {
    if (currentExpr.isEmpty) return currentExpr;
    if (currentExpr.startsWith('-')) return currentExpr.substring(1);
    return '-$currentExpr';
  }

  static String convertBase(String value, int oldBase, int newBase) {
    if (value.isEmpty || value == 'Error') return value;
    try {
      BigInt number = BigInt.parse(value, radix: oldBase);

      return number.toRadixString(newBase).toUpperCase();
    } catch (e) {
      return '0'; // Reset về 0 nếu lỗi
    }
  }

  static String calculateBitwise(String expression, int base) {
    try {
      List<String> operators = ['AND', 'OR', 'XOR', 'NOT', '<<', '>>'];
      String op = '';
      for (var o in operators) {
        if (expression.contains(o)) {
          op = o;
          break;
        }
      }

      if (op.isEmpty) return expression;

      if (op == 'NOT') {
        String valStr = expression.replaceAll('NOT', '').trim();
        BigInt val = BigInt.parse(valStr, radix: base);

        return (~val).toRadixString(base).toUpperCase();
      }

      List<String> parts = expression.split(op);
      if (parts.length != 2) return "Error";

      BigInt left = BigInt.parse(parts[0].trim(), radix: base);
      BigInt right = BigInt.parse(parts[1].trim(), radix: base);
      BigInt result;

      switch (op) {
        case 'AND':
          result = left & right;
          break;
        case 'OR':
          result = left | right;
          break;
        case 'XOR':
          result = left ^ right;
          break;
        case '<<':
          result = left << right.toInt();
          break;
        case '>>':
          result = left >> right.toInt();
          break;
        default:
          return "Error";
      }

      return result.toRadixString(base).toUpperCase();
    } catch (e) {
      return 'Error';
    }
  }
}
