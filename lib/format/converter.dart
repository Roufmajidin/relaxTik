import 'package:intl/intl.dart';

class DateFormatter {
  static String formatToDDMMYYYY(DateTime date) {
    return DateFormat('dd MM yyyy').format(date);
  }

  static String formatToDDMMYYYYWithMonthName(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }
}

class FormatRupiah {
  static String format(double amount) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return formatCurrency.format(amount);
  }

  // Metode lain dapat ditambahkan di sini sesuai kebutuhan
}
