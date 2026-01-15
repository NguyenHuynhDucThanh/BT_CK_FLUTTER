import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyUtils {
  static String formatVND(dynamic amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);
    return formatter.format(amount ?? 0);
  }

  static double parseVND(String formattedString) {
    if (formattedString.isEmpty) return 0;
    String cleanString = formattedString.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleanString) ?? 0;
  }
}

// BỘ ĐỊNH DẠNG KHI ĐANG GÕ (MỚI)
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) return newValue;

    // Lấy giá trị số nguyên thủy
    String cleanString = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanString.isEmpty) return newValue.copyWith(text: '');

    double value = double.parse(cleanString);
    final formatter = NumberFormat.decimalPattern('vi'); // Dùng chuẩn VN để có dấu chấm
    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}