T minMax<T extends num>(T v, T min, T max) {
  return v > max
      ? max
      : v < min
          ? min
          : v;
}
