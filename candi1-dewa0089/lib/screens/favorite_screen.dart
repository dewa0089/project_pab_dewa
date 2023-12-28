import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_shop/data/shoes.dart';
import 'package:shoes_shop/model/shoes.dart';
import 'package:shoes_shop/widgets/item_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Shoes> favoriteShoes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteShoes();
  }

  Future<void> _loadFavoriteShoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteShoeIds = [];
    prefs.getKeys().forEach((key) {
      if (key.startsWith('favorite_') && prefs.getBool(key) == true) {
        favoriteShoeIds.add(key.substring('favorite_'.length) != null
            ? key.substring('favorite_'.length)
            : '');
      }
    });

    setState(() {
      favoriteShoes = shoesList.where((shoes) {
        return favoriteShoeIds.contains(shoes.id.toString());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Shoes'),
      ),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: favoriteShoes.length,
        itemBuilder: (context, index) {
          Shoes shoes = favoriteShoes[index];
          return ItemCard(shoes: shoes);
        },
      ),
    );
  }
}
