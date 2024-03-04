extension EnumExtensions<T extends Enum> on T {
  int nextIndex(List<T> values) {
    return (index + 1) % values.length;
  }

  T next(List<T> values) {
    return values[nextIndex(values)];
  }
}
