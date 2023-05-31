
typedef ElementIndexedMapper<T, E> = T Function(E element, int index);
typedef TestListPredicate<E> = bool Function(E e);

extension ListsExtensions<E> on List<E> {
  List<T> mapIndexed<T>(ElementIndexedMapper<T, E> mapper) {
    final list = <T>[];
    for (int i = 0; i < length; i++) {
      list.add(mapper(this[i], i));
    }
    return list;
  }

  int? firstIndexWhere(TestListPredicate<E> test) {
    final index = indexWhere((element) => test(element));
    if (index == -1) {
      return null;
    } else {
      return index;
    }
  }

}
