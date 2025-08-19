import 'package:hive/hive.dart';

part 'category_entity.g.dart';

@HiveType(typeId: 1)
class CategoryEntity extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String icon;

  @HiveField(2)
  final String color;

  CategoryEntity({
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity &&
        other.name == name &&
        other.icon == icon &&
        other.color == color;
  }

  @override
  int get hashCode => name.hashCode ^ icon.hashCode ^ color.hashCode;

  @override
  String toString() =>
      'CategoryEntity(name: $name, icon: $icon, color: $color)';
}
