class Situation {
  final String name;
  final List<Item> items;

  Situation({required this.name, required this.items});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  static Situation fromJson(Map<String, dynamic> json) {
    return Situation(
      name: json['name'],
      items: (json['items'] as List<dynamic>)
          .map((item) => Item.fromJson(item))
          .toList(),
    );
  }
}

class Item {
  final String name;
  final String location;
  bool isChecked;

  Item({required this.name, required this.location, this.isChecked = false});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'isChecked': isChecked,
    };
  }

  static Item fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      location: json['location'],
      isChecked: json['isChecked'] ?? false,
    );
  }
}
