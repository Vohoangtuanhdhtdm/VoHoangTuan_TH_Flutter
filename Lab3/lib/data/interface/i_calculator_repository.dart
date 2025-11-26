abstract class ICalculatorRepository {
  Future<void> saveHistory(List<String> history);
  Future<List<String>> getHistory();
}
