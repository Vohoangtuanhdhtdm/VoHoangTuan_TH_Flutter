import 'package:flutter_calculator_vohoangtuan/presentation/logic/providers/di_providers.dart';
import 'package:flutter_calculator_vohoangtuan/presentation/logic/states/calculator_state.dart';
import 'package:flutter_calculator_vohoangtuan/utils/calculator_logic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorNotifier extends Notifier<CalculatorState> {
  @override
  CalculatorState build() {
    _loadHistory();
    return CalculatorState();
  }

  Future<void> _loadHistory() async {
    final repository = ref.read(calculatorRepositoryProvider);
    final history = await repository.getHistory();
    state = state.copyWith(history: history);
  }

  void toggleDegreeMode() {
    state = state.copyWith(isDegree: !state.isDegree);
  }

  void switchMode() {
    final nextMode = CalculatorMode
        .values[(state.mode.index + 1) % CalculatorMode.values.length];

    if (nextMode == CalculatorMode.programmer) {
      String cleanRes = state.result.contains('.')
          ? state.result.split('.')[0]
          : state.result;
      String cleanExpr = state.expression.contains('.')
          ? state.expression.split('.')[0]
          : state.expression;

      state = state.copyWith(
        mode: nextMode,
        base: 10,
        result: cleanRes,
        expression: cleanExpr,
      );
    } else {
      state = state.copyWith(mode: nextMode);
    }
  }

  void switchBase(int newBase) {
    if (state.mode != CalculatorMode.programmer) return;

    String newResult = CalculatorLogic.convertBase(
      state.result,
      state.base,
      newBase,
    );
    String newExpr = CalculatorLogic.convertBase(
      state.expression,
      state.base,
      newBase,
    );

    state = state.copyWith(
      base: newBase,
      result: newResult,
      expression: newExpr,
    );
  }

  void onMemoryPressed(String label) {
    if (label == 'MC') {
      state = state.copyWith(memoryValue: 0.0);
      return;
    }

    if (label == 'MR') {
      String valueToPaste = state.memoryValue.toString();
      if (state.memoryValue % 1 == 0) {
        valueToPaste = state.memoryValue.toInt().toString();
      }
      state = state.copyWith(expression: state.expression + valueToPaste);
      return;
    }

    if (label == 'M+' || label == 'M-') {
      double valueToProcess = 0.0;
      String stringToParse = state.expression.isEmpty
          ? state.result
          : state.expression;

      try {
        String calculatedStr = CalculatorLogic.calculate(
          stringToParse,
          isDegree: state.isDegree,
        );
        if (calculatedStr == 'Error' || calculatedStr == 'Infinite') return;
        valueToProcess = double.parse(calculatedStr);
      } catch (e) {
        return;
      }

      double newMemory = state.memoryValue;
      if (label == 'M+')
        newMemory += valueToProcess;
      else
        newMemory -= valueToProcess;

      state = state.copyWith(memoryValue: newMemory);
    }
  }

  void onButtonPressed(String label) {
    if (['MC', 'MR', 'M+', 'M-'].contains(label)) {
      onMemoryPressed(label);
      return;
    }

    if (label == 'C') {
      state = state.copyWith(expression: '', result: '0');
      return;
    }

    if (label == '⌫') {
      if (state.expression.isNotEmpty) {
        state = state.copyWith(
          expression: state.expression.substring(
            0,
            state.expression.length - 1,
          ),
        );
      }
      return;
    }

    if (label == '=') {
      if (state.mode == CalculatorMode.programmer) {
        final res = CalculatorLogic.calculateBitwise(
          state.expression,
          state.base,
        );

        state = state.copyWith(result: res, expression: res);
        return;
      } else {
        final finalResult = CalculatorLogic.calculate(
          state.expression,
          isDegree: state.isDegree,
        );

        if (finalResult != 'Error') {
          final newHistory = [
            ...state.history,
            '${state.expression} = $finalResult',
          ];
          ref.read(calculatorRepositoryProvider).saveHistory(newHistory);
          state = state.copyWith(result: finalResult, history: newHistory);
        } else {
          state = state.copyWith(result: finalResult);
        }
        return;
      }
    }

    if (label == '+/-') {
      final newExpr = CalculatorLogic.toggleSign(state.expression);
      state = state.copyWith(expression: newExpr);
      return;
    }

    if (['AND', 'OR', 'XOR', 'NOT', '<<', '>>'].contains(label)) {
      state = state.copyWith(expression: "${state.expression} $label ");
      return;
    }

    if (['sin', 'cos', 'tan', 'log', 'ln', '√'].contains(label)) {
      state = state.copyWith(expression: state.expression + '$label(');
      return;
    }
    if (label == 'xʸ') {
      state = state.copyWith(expression: state.expression + '^');
      return;
    }

    state = state.copyWith(expression: state.expression + label);
  }
}

final calculatorProvider =
    NotifierProvider<CalculatorNotifier, CalculatorState>(() {
      return CalculatorNotifier();
    });
