/// 정수 가격을 1,000 단위 구분자 포함 문자열로 포맷.
///
/// 예: 1234567 → '1,234,567'
String formatPrice(int won) {
  final s = won.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
