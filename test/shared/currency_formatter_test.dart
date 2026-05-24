import 'package:flutter_test/flutter_test.dart';
import 'package:easy_finance_calculator/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('formats THB correctly', () {
      final result = CurrencyFormatter.format(1234.56, currencyCode: 'THB');
      expect(result, contains('฿'));
      expect(result, contains('1,234.56'));
    });

    test('formats USD correctly', () {
      final result = CurrencyFormatter.format(9999.99, currencyCode: 'USD');
      expect(result, contains('\$'));
      expect(result, contains('9,999.99'));
    });

    test('compact format uses K for thousands', () {
      final result = CurrencyFormatter.format(5000, compact: true);
      expect(result, contains('K'));
    });

    test('compact format uses M for millions', () {
      final result =
          CurrencyFormatter.format(2500000, compact: true, currencyCode: 'USD');
      expect(result, contains('M'));
    });

    test('formats percent correctly', () {
      expect(CurrencyFormatter.formatPercent(12.345), equals('12.35%'));
      expect(CurrencyFormatter.formatPercent(100), equals('100.00%'));
    });

    test('tryParse returns null for invalid input', () {
      expect(CurrencyFormatter.tryParse('abc'), isNull);
      expect(CurrencyFormatter.tryParse(''), isNull);
    });

    test('tryParse handles currency-prefixed string', () {
      expect(CurrencyFormatter.tryParse('฿1234.56'), closeTo(1234.56, 0.001));
    });

    test('formatNoDecimal strips decimals', () {
      final result =
          CurrencyFormatter.formatNoDecimal(50000.00, currencyCode: 'THB');
      expect(result, isNot(contains('.')));
      expect(result, contains('50,000'));
    });
  });
}
