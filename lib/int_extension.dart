import 'dart:math';

import 'package:packagist_extensions/extensions.dart';

extension IntExtension on int? {
  int get positive {
    if (this == null) return 0;
    return this! > 0 ? this! : 0;
  }

  /// for ex. add comma in price
  String thousandsSeparator({String separator = ','}) {
    return positive.toString().thousandsSeparator(separator: separator);
  }

  int get random {
    if (this == null) return 0;
    return Random().nextInt(this!);
  }
}
