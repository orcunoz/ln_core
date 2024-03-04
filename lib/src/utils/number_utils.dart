final class NumberUtils {
  NumberUtils._();

  static const int maxInt =
      (double.infinity is int) ? double.infinity as int : ~NumberUtils.minInt;
  static const int minInt =
      (double.infinity is int) ? -double.infinity as int : (-1 << 63);
}
