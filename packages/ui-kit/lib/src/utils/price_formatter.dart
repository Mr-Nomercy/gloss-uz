library price_formatter;

/// Formats price in Uzbek format: 25 000 so'm
String formatPrice(num price) {
  final whole = price.toInt();
  final buffer = StringBuffer();
  final str = whole.toString();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(str[i]);
  }
  return '${buffer.toString()} so\'m';
}

/// Formats price without currency suffix
String formatNumber(num price) {
  final whole = price.toInt();
  final buffer = StringBuffer();
  final str = whole.toString();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(str[i]);
  }
  return buffer.toString();
}