import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/presentation/logic/states/calculator_state.dart';
import 'package:flutter_calculator_vohoangtuan/presentation/ui/screens/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../presentation/logic/providers/calculator_provider.dart';
import '../widgets/calculator_button.dart';

class CalculatorPage extends ConsumerWidget {
  const CalculatorPage({super.key});

  static const List<List<String>> basicKeys = [
    ['C', '⌫', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['+/-', '0', '.', '='],
  ];

  static const List<List<String>> scientificKeys = [
    ['2nd', 'deg', 'sin', 'cos', 'tan'],
    ['xʸ', 'log', 'ln', '(', ')'],
    ['MC', 'MR', 'M+', 'M-', '÷'],
    ['C', '7', '8', '9', '×'],
    ['⌫', '4', '5', '6', '-'],
    ['1', '2', '3', 'π', '+'],
    ['+/-', '0', '.', '√', '='],
  ];

  static const List<List<String>> programmerKeys = [
    ['A', '<<', '>>', 'C', '⌫'],
    ['B', '(', ')', 'NOT', '÷'],
    ['C', '7', '8', '9', '×'],
    ['D', '4', '5', '6', '-'],
    ['E', '1', '2', '3', '+'],
    ['F', '00', '0', '.', '='],
    ['AND', 'OR', 'XOR', '%', 'M+'],
  ];

  Color getButtonColor(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Nút Xóa/Clear
    if (label == 'C' || label == '⌫') {
      return colorScheme.tertiary;
    }

    // Nút Bằng
    if (label == '=') {
      return colorScheme.surface;
    }

    // Nút Phép tính & Memory
    if ([
      '÷', '×', '-', '+', '%', '^', '√',
      'M+', 'M-', 'MR', 'MC',
      'AND', 'OR', 'XOR', 'NOT', '<<', '>>', // Thêm toán tử Bitwise
    ].contains(label)) {
      return colorScheme.secondary;
    }

    // Nút Hex (A-F)
    if (['A', 'B', 'C', 'D', 'E', 'F'].contains(label)) {
      return colorScheme.tertiaryContainer;
    }

    // Nút Hàm Khoa học
    if ([
      'sin',
      'cos',
      'tan',
      'log',
      'ln',
      '(',
      ')',
      'deg',
      'rad',
      '2nd',
      'xʸ',
      'π',
      'e',
      'abs',
    ].contains(label)) {
      return isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);
    }

    // Nút Số mặc định
    return colorScheme.primary;
  }

  Widget _buildBaseButton(
    BuildContext context,
    WidgetRef ref,
    String label,
    int value,
    int currentBase,
  ) {
    final isSelected = value == currentBase;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => ref.read(calculatorProvider.notifier).switchBase(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.orange
                : colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculatorState = ref.watch(calculatorProvider);
    final controller = ref.read(calculatorProvider.notifier);

    // Lấy màu text động theo theme
    final displayTextColor =
        Theme.of(context).textTheme.displayLarge?.color ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black);

    List<List<String>> currentKeys;
    if (calculatorState.mode == CalculatorMode.programmer) {
      currentKeys = programmerKeys;
    } else if (calculatorState.mode == CalculatorMode.scientific) {
      currentKeys = scientificKeys;
    } else {
      currentKeys = basicKeys;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VHT Calculator",
          style: TextStyle(color: displayTextColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: displayTextColor),
        actions: [
          // Nút chuyển chế độ (Basic -> Scientific -> Programmer)
          IconButton(
            icon: Icon(switch (calculatorState.mode) {
              CalculatorMode.basic => Icons.calculate,
              CalculatorMode.scientific => Icons.science,
              CalculatorMode.programmer => Icons.computer,
            }),
            onPressed: () => controller.switchMode(), // Gọi hàm switchMode mới
            tooltip: "Chuyển chế độ",
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Text(
                'Lịch sử',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ...calculatorState.history.reversed.map(
              (e) => ListTile(title: Text(e)),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                alignment: Alignment.bottomRight,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (calculatorState.mode == CalculatorMode.programmer)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildBaseButton(
                                context,
                                ref,
                                "HEX",
                                16,
                                calculatorState.base,
                              ),
                              _buildBaseButton(
                                context,
                                ref,
                                "DEC",
                                10,
                                calculatorState.base,
                              ),
                              _buildBaseButton(
                                context,
                                ref,
                                "OCT",
                                8,
                                calculatorState.base,
                              ),
                              _buildBaseButton(
                                context,
                                ref,
                                "BIN",
                                2,
                                calculatorState.base,
                              ),
                            ],
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (calculatorState.memoryValue != 0)
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  "M",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                            // Chỉ hiện DEG/RAD ở chế độ Khoa học
                            if (calculatorState.mode ==
                                CalculatorMode.scientific)
                              Text(
                                calculatorState.isDegree ? "DEG" : "RAD",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                          ],
                        ),
                      ),

                      Text(
                        calculatorState.expression,
                        style: TextStyle(
                          color: displayTextColor.withOpacity(0.6),
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          calculatorState.result,
                          style: TextStyle(
                            color: displayTextColor,
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (calculatorState.mode == CalculatorMode.scientific ||
                            calculatorState.mode == CalculatorMode.programmer)
                        ? 5
                        : 4,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: currentKeys.expand((row) => row).length,
                  itemBuilder: (context, index) {
                    final allKeys = currentKeys.expand((row) => row).toList();
                    final label = allKeys[index];

                    return CalculatorButton(
                      label: label,
                      background: getButtonColor(context, label),
                      onTap: () {
                        if (label == 'deg' || label == 'rad') {
                          controller.toggleDegreeMode();
                        } else {
                          controller.onButtonPressed(label);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
