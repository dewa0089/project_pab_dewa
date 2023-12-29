

class Shoes {
  final int id;
  final String name;
  final String model;
  final String description;
  final double price;
  final String imageAsset;
  bool isFavorite;
  final String category;
  final List<int> size;
  final double rating;

  Shoes({
    required this.id,
    required this.name,
    required this.model,
    required this.description,
    required this.price,
    required this.imageAsset,
    this.isFavorite = false,
    required this.category,
    required this.size,
    required this.rating,
  });
}
