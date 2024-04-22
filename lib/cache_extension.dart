import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

extension SharedPreferencesExt on dynamic {
  bool getBool({bool defaultValue = false}) {
    return toBool(_value, defaultValue: defaultValue);
  }

  int getInt({int defaultValue = 0}) {
    return toInt(_value, defaultValue: defaultValue);
  }

  double getDouble({double defaultValue = 0.0}) {
    return toDouble(_value, defaultValue: defaultValue);
  }

  String getString({String defaultValue = ""}) {
    return toString(_value, defaultValue: defaultValue);
  }

  List<String> getStringList({List<String>? defaultValue}) {
    List<dynamic> list = toList(_value, defaultValue: defaultValue);
    return list is List<String> ? list : defaultValue ?? [];
  }

  void setBool(bool value) {
    SharedPreferencesInstance.sp?.setBool(_key, value);
  }

  void setInt(int value) {
    SharedPreferencesInstance.sp?.setInt(_key, value);
  }

  void setDouble(double value) {
    SharedPreferencesInstance.sp?.setDouble(_key, value);
  }

  void setString(String value) {
    SharedPreferencesInstance.sp?.setString(_key, value);
  }

  void setStringList(List<String> value) {
    SharedPreferencesInstance.sp?.setStringList(_key, value);
  }

  void remove() {
    SharedPreferencesInstance.sp?.remove(_key);
  }

  String get _key {
    if (this is Enum) {
      return this.toString().split('.').last;
    } else if (this is String) {
      return this;
    }
    return this.toString();
  }

  dynamic get _value {
    return SharedPreferencesInstance.sp?.get(_key);
  }
}

class SharedPreferencesInstance {
  static final Lock _lock = Lock();
  static SharedPreferences? _sharedPreferences;

  static Future init() async {
    if (_sharedPreferences == null) {
      await _lock.synchronized(() async {
        _sharedPreferences ??= await SharedPreferences.getInstance();
      });
    }
  }

  static SharedPreferences? get sp => _sharedPreferences;

  static Future<bool> clear() async {
    return await _sharedPreferences?.clear() ?? false;
  }
}

int toInt(value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is bool) return value ? 1 : 0;
  if (value is String) {
    return int.tryParse(value) ??
        double.tryParse(value)?.toInt() ??
        defaultValue;
  }
  return defaultValue;
}

double toDouble(value, {double defaultValue = 0.0}) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is bool) return value ? 1.0 : 0.0;
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

bool toBool(value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is int) return value == 0 ? false : true;
  if (value is double) return value == 0 ? false : true;
  if (value is String) {
    if (value == "1" || value.toLowerCase() == "true") return true;
    if (value == "0" || value.toLowerCase() == "false") return false;
  }
  return defaultValue;
}

String toString(value, {String defaultValue = ""}) {
  if (value == null) return defaultValue;
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value is double) return value.toString();
  if (value is bool) return value ? "true" : "false";
  return defaultValue;
}

List toList(value, {List? defaultValue}) {
  if (value == null) return defaultValue ?? [];
  if (value is List) return value;
  return defaultValue ?? [];
}
