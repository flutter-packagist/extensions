import 'package:intl/intl.dart';

/// 日期扩展
extension DateTimeExtension on DateTime {
  /// timestamp seconds
  int get timeStamp {
    return (millisecondsSinceEpoch ~/ 1000).toInt();
  }

  /// 是否为今天
  bool get isToday {
    final nowDate = DateTime.now();
    return year == nowDate.year && month == nowDate.month && day == nowDate.day;
  }

  /// 是否为昨天
  bool get isYesterday {
    final nowDate = DateTime.now();
    return year == nowDate.year &&
        month == nowDate.month &&
        day == nowDate.day - 1;
  }

  /// 是否为明天
  bool get isTomorrow {
    final nowDate = DateTime.now();
    return year == nowDate.year &&
        month == nowDate.month &&
        day == nowDate.day + 1;
  }

  /// 获取指定格式的当前时间
  String format([String format = "yyyy-MM-dd HH:mm:ss"]) {
    return DateFormat(format).format(this);
  }
}
