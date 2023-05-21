abstract class HiveDB<T> {
  Future<void> put(T? t);
  Future<void> deleteAll();
  T? getFirst();
}