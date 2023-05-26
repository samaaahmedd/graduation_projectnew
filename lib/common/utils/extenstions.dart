
typedef ElementIndexedMapper<T, E> = T Function(E element, int index);

extension ListsExtensions<E> on List<E> {
  List<T> mapIndexed<T>(ElementIndexedMapper<T, E> mapper) {
    final list = <T>[];
    for (int i = 0; i < length; i++) {
      list.add(mapper(this[i], i));
    }
    return list;
  }
}
