import 'package:extensions/string_extension.dart';

extension DoubleExtension on double? {
  double get positive {
    if (this == null) return 0.0;
    return this! > 0.0 ? this! : 0.0;
  }

  /// for ex. add comma in price
  String thousandsSeparator({String separator = ','}) {
    return positive.toString().thousandsSeparator(separator: separator);
  }
}
