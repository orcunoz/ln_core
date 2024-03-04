extension IterableExtensions<T> on Iterable<T> {
  double sumOf(double? Function(T) valueGetter) {
    double sum = 0;
    for (var item in this) {
      final value = valueGetter(item);
      if (value != null) {
        sum += value;
      }
    }
    return sum;
  }
}
