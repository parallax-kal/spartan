List<Map<DateTime, List<T>>> sortItems<T extends HasCreatedAt>(List<T> items) {
  Map<DateTime, List<T>> sortedItems = {};

  for (T log in items) {
    DateTime date = log.createdAt;
    DateTime day = DateTime(date.year, date.month, date.day);

    if (sortedItems.containsKey(day)) {
      sortedItems[day]!.add(log);
    } else {
      sortedItems[day] = [log];
    }
  }

  List<Map<DateTime, List<T>>> sortedList = [];

  sortedItems.forEach((key, value) {
    sortedList.add({key: value});
  });

  return sortedList;
}

abstract class HasCreatedAt {
  DateTime get createdAt;
}
