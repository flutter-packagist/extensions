# Extensions

- [Example](https://github.com/flutter-packagist/extensions)

## int Extension

+ positive
+ thousandsSeparator()

``` dart
test("int extension", () {
  int price = 123456789;
  int priceNegative = -123456789;
  expect(price.positive, 123456789);
  expect(priceNegative.positive, 0);
  expect(price.thousandsSeparator(), "123,456,789");
  expect(priceNegative.thousandsSeparator(), "0");
});
```

## double Extension

+ positive
+ thousandsSeparator()

``` dart
test("double extension", () {
  double price = 123456789.11;
  double priceInteger = 123456789;
  double priceNegative = -123456789.11;
  expect(price.positive, 123456789.11);
  expect(priceInteger.positive, 123456789);
  expect(priceNegative.positive, 0);
  expect(price.thousandsSeparator(), "123,456,789.11");
  expect(priceInteger.thousandsSeparator(), "123,456,789.0");
  expect(priceNegative.thousandsSeparator(), "0.0");
});
```

## String Extension

+ isNull
+ isNullOrEmpty
+ isNotNullOrEmpty
+ enumValue
+ validate()
+ toInt()
+ toDouble()
+ thousandsSeparator()
+ capitalizeFirstLetter()
+ capitalizeEachWord()
+ removeAllWhiteSpace()
+ countWords()
+ toSlug()
+ renderHtml
+ reverse
+ isDigit
+ isAlpha
+ validateEmail()
+ validateEmailEnhanced()
+ validatePhoneCN()
+ validateURL()
+ isImage
+ isAudio
+ isVideo
+ isTxt
+ isDoc
+ isExcel
+ isPPT
+ isApk
+ isPdf
+ isHtml

``` dart
test("String extension", () {
  String price = "123456789";
  expect(price.isNull, false);
  expect(price.isNullOrEmpty, false);
  expect(price.isNotNullOrEmpty, true);
  String priceEnum = Price.price1.toString();
  expect(priceEnum.enumValue, Price.price1.name);
  String? priceNull;
  expect(priceNull.validate("123"), "123");
  expect("123456789".toInt(), 123456789);
  expect("123456789.00".toDouble(), 123456789);
  expect("123456789.11".thousandsSeparator(), "123,456,789.11");
  expect("hello world !".capitalizeFirstLetter(), "Hello world !");
  expect("hello world !".capitalizeEachWord(), "Hello World !");
  expect("hello world !".removeAllWhiteSpace(), "helloworld!");
  expect("hello world !".countWords(), 3);
  expect("hello world !".toSlug(), "hello_world_!");
  expect("&lt;hello <br>world <br/>!&gt;".renderHtml, "<hello \nworld \n!>");
  expect("hello world !".reverse, "! dlrow olleh");
  expect("hello world !".isDigit, false);
  expect("hello".isAlpha, true);
  expect("hello@qq.com".validateEmail(), true);
  expect("hello@11.com".validateEmailEnhanced(), true);
  expect("1571231234".validatePhoneCN(), true);
  expect("http://www.baidu.com".validateURL(), true);
  expect("111.png".isImage, true);
  expect("111.mp3".isAudio, true);
  expect("111.mp4".isVideo, true);
  expect("111.txt".isTxt, true);
  expect("111.doc".isDoc, true);
  expect("111.xls".isExcel, true);
  expect("111.pptx".isPPT, true);
  expect("111.apk".isApk, true);
  expect("111.pdf".isPdf, true);
  expect("111.html".isHtml, true);
});
```

## list Extension

+ isNull
+ isNullOrEmpty
+ isNotNullOrEmpty
+ item()
+ removeSafeAt()
+ insertSafe()
+ insertHead()
+ insertTail()

``` dart
test("list extension", () {
  List<int> list = [1, 2, 3];
  expect(list.isNull, false);
  expect(list.isNullOrEmpty, false);
  expect(list.isNotNullOrEmpty, true);
  expect(list.item(0), 1);
  expect(list.removeSafeAt(0), 1);
  expect(list.insertSafe(0, 1), true);
  expect(list.insertHead(0), true);
  expect(list.insertTail(4), true);
  expect(list, [0, 1, 2, 3, 4]);
});
```

## map Extension

+ value()
+ add()

``` dart
test("map extension", () {
  Map<String, int> map = {"a": 1, "b": 2};
  expect(map.value("a"), 1);
  expect(map.add("c", 3), 3);
  expect(map, {"a": 1, "b": 2, "c": 3});
});
```

## DateTimeExtension

+ isToday
+ isYesterday
+ isTomorrow
+ timeStamp
+ format()

``` dart
test("datetime extension", () {
  final now = DateTime(2023, 8, 11, 16, 22, 0, 0);
  expect(now.isToday, true);
  expect(now.isYesterday, false);
  expect(now.isTomorrow, false);
  expect(now.format(), "2023-08-11 16:22:00");
  expect(now.format("yyyy年MM月dd日"), "2023年08月11日");
  expect(now.millisecondsSinceEpoch, 1691742120000);
  expect(now.timeStamp, 1691742120);
});
```

## Gesture Extension

+ debounce()
+ throttle()

``` dart
Text(
  model.count.toString(),
  style: const TextStyle(fontSize: 40),
),
const SizedBox(height: 20),
TextButton(
  onPressed: controller.onTap,
  child: const Text('正常'),
),
const SizedBox(height: 20),
TextButton(
  onPressed: controller.onTap.debounce(),
  child: const Text('防抖'),
),
const SizedBox(height: 20),
TextButton(
  onPressed: controller.onTapDelay.throttle(),
  child: const Text('节流'),
),
const SizedBox(height: 20),
TextButton(
  onPressed: controller.onTap.throttle(timeout: 3000),
  child: const Text('3秒节流'),
),
```

## Permission Extension

+ use(onAccept: () {}, onDenied: () {})

> 1. 申请权限被永久拒绝后统一处理
> 2. 适配Android 13权限变更（多媒体资源访问）

``` dart
Permission.camera.use(
  onAccept: (status) {
    // do something
  },
  onDenied: (status) {
    // do something
  },
);
```