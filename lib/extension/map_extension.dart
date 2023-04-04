extension MaxValues on Map<int, int> {
  List<int> get maxValues {
    var maxValue = 0;
    final result = <int>[];

    forEach((key, value) {
      if (value > maxValue) {
        result
          ..clear()
          ..add(key);
        maxValue = value;
      } else if (value == maxValue) {
        result.add(key);
      }
    });

    return maxValue > 0 ? result : [];
  }
}
