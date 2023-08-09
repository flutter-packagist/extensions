extension MapExtension<K, V> on Map<K, V>? {
  V? value(K key) {
    if (this == null) return null;
    if (this!.containsKey(key)) {
      return this![key];
    } else {
      return null;
    }
  }

  V? add(K key, V value) {
    if (this == null) return null;
    V? result;
    if (this!.containsKey(key)) {
      result = this!.update(key, (_) => value);
    } else {
      result = this!.putIfAbsent(key, () => value);
    }
    return result;
  }
}
