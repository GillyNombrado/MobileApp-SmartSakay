List<String> navHistory = [];

void addHistory(String text) {
  final now = DateTime.now();
  final h = now.hour.toString().padLeft(2, '0');
  final m = now.minute.toString().padLeft(2, '0');
  navHistory.add("$h:$m - $text");
}