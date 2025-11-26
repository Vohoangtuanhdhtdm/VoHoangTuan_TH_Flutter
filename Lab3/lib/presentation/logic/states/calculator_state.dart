enum CalculatorMode { basic, scientific, programmer }

class CalculatorState {
  final String expression;
  final String result;
  final List<String> history;

  final CalculatorMode mode;
  final bool isDegree;

  final double memoryValue;

  // Biến lưu hệ cơ số hiện tại (10, 16, 8, 2)
  final int base;

  CalculatorState({
    this.expression = '',
    this.result = '0',
    this.history = const [],
    this.mode = CalculatorMode.basic, // Mặc định là Basic

    this.isDegree = false,
    this.memoryValue = 0.0,
    this.base = 10, // Mặc định là Decimal
  });

  // Để thay cập nhật phép tính
  CalculatorState copyWith({
    String? expression,
    String? result,
    List<String>? history,
    CalculatorMode? mode,

    bool? isDegree,
    double? memoryValue,
    int? base,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      history: history ?? this.history,
      mode: mode ?? this.mode,
      isDegree: isDegree ?? this.isDegree,
      memoryValue: memoryValue ?? this.memoryValue,
      base: base ?? this.base,
    );
  }
}
