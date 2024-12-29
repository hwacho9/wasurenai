class Situation {
  final String name;
  final List<Item> items;

  Situation({required this.name, required this.items});
}

class Item {
  final String name;
  final String location;
  bool isChecked;

  Item({required this.name, required this.location, this.isChecked = false});
}
