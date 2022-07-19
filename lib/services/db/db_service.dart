
abstract class DBService<T> {

  void put(T t);

  void deleteAll();

  T? getFirst();
}