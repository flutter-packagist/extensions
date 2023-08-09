extension StringExtension on String? {
  bool get isNull => this == null;

  bool get isNullOrEmpty => isNull || this!.isEmpty || this == "null";

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// 获取枚举字符串
  String get enumValue {
    if (isNullOrEmpty) return "";
    var array = this!.split(".");
    if (array.length == 2) return array[1];
    return "";
  }

  /// Check null string, return given value if null
  String validate({String value = ''}) => isNullOrEmpty ? value : this!;

  /// Return int value of given string
  int toInt({int defaultValue = 0}) {
    if (this == null) return defaultValue;

    if (isDigit) {
      return int.parse(this!);
    } else {
      return defaultValue;
    }
  }

  /// Return double value of given string
  double toDouble({double defaultValue = 0.0}) {
    if (this == null) return defaultValue;

    try {
      return double.parse(this!);
    } catch (e) {
      return defaultValue;
    }
  }

  /// for ex. add comma in price
  String thousandsSeparator({String separator = ','}) {
    return validate().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}$separator');
  }

  /// Capitalize given String
  String capitalizeFirstLetter() => (validate().isNotEmpty)
      ? (this!.substring(0, 1).toUpperCase() + this!.substring(1).toLowerCase())
      : validate();

  /// This function returns given string with each word capital
  String capitalizeEachWord() {
    if (validate().isEmpty) {
      return '';
    }

    final capitalizedWords = this!.split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      final firstLetter = word[0].toUpperCase();
      final remainingLetters = word.substring(1).toLowerCase();
      return '$firstLetter$remainingLetters';
    });

    return capitalizedWords.join(' ');
  }

  /// Removes white space from given String
  String removeAllWhiteSpace() =>
      validate().replaceAll(RegExp(r"\s+\b|\b\s"), "");

  List<String> toList() => validate().trim().split('');

  /// Return number of words ina given String
  int countWords() {
    var words = validate().trim().split(RegExp(r'(\s+)'));
    return words.length;
  }

  /// Generate slug of a given String
  String toSlug({String delimiter = '_'}) {
    String text = validate().trim().toLowerCase();
    return text.replaceAll(' ', delimiter);
  }

  /// Render a HTML String
  String get renderHtml {
    return this!
        .replaceAll('&ensp;', ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&emsp;', ' ')
        .replaceAll('<br>', '\n')
        .replaceAll('<br/>', '\n')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }

  /// It reverses the String
  String get reverse {
    if (isNullOrEmpty) return '';
    return toList().reversed.reduce((value, element) => value += element);
  }

  /// Return true if given String is Digit
  bool get isDigit {
    if (validate().isEmpty) {
      return false;
    }
    if (validate().length > 1) {
      for (var r in this!.runes) {
        if (r ^ 0x30 > 9) {
          return false;
        }
      }
      return true;
    } else {
      return this!.runes.first ^ 0x30 <= 9;
    }
  }

  /// Check weather String is alpha or not
  bool get isAlpha => Patterns.hasMatch(this, Patterns.alpha);

  /// Check email validation
  bool validateEmail() => Patterns.hasMatch(this, Patterns.email);

  /// Check email validation
  bool validateEmailEnhanced() =>
      Patterns.hasMatch(this, Patterns.emailEnhanced);

  /// Check phone validation
  bool validatePhone() => Patterns.hasMatch(this, Patterns.phone);

  /// Check URL validation
  bool validateURL() => Patterns.hasMatch(this, Patterns.url);

  /// Image regex
  bool get isImage => Patterns.hasMatch(this, Patterns.image);

  /// Audio regex
  bool get isAudio => Patterns.hasMatch(this, Patterns.audio);

  /// Video regex
  bool get isVideo => Patterns.hasMatch(this, Patterns.video);

  /// Txt regex
  bool get isTxt => Patterns.hasMatch(this, Patterns.txt);

  /// Document regex
  bool get isDoc => Patterns.hasMatch(this, Patterns.doc);

  /// Excel regex
  bool get isExcel => Patterns.hasMatch(this, Patterns.excel);

  /// PPT regex
  bool get isPPT => Patterns.hasMatch(this, Patterns.ppt);

  /// Document regex
  bool get isApk => Patterns.hasMatch(this, Patterns.apk);

  /// PDF regex
  bool get isPdf => Patterns.hasMatch(this, Patterns.pdf);

  /// HTML regex
  bool get isHtml => Patterns.hasMatch(this, Patterns.html);
}

class Patterns {
  /// has match return bool for pattern matching
  static bool hasMatch(String? s, String p) {
    return (s == null) ? false : RegExp(p).hasMatch(s);
  }

  static String alpha = r'^[a-zA-Z]+$';

  static String url =
      r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';

  static String phone = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  static String email =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static String emailEnhanced =
      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

  static String image = r'.(jpeg|jpg|gif|png|bmp|webp)$';

  /// Audio regex
  static String audio = r'.(mp3|wav|wma|amr|ogg)$';

  /// Video regex
  static String video = r'.(mp4|avi|wmv|rmvb|mpg|mpeg|3gp|mkv)$';

  /// Txt regex
  static String txt = r'.txt$';

  /// Document regex
  static String doc = r'.(doc|docx)$';

  /// Excel regex
  static String excel = r'.(xls|xlsx)$';

  /// PPT regex
  static String ppt = r'.(ppt|pptx)$';

  /// Document regex
  static String apk = r'.apk$';

  /// PDF regex
  static String pdf = r'.pdf$';

  /// HTML regex
  static String html = r'.html$';
}
