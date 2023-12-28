import 'package:flutter/material.dart';
// import 'package:shoes_shop/animation/fadeanimation.dart';
import 'package:shoes_shop/screens/search_screen.dart';
import 'package:shoes_shop/screens/body_home.dart';
// import 'package:shoes_shop/widgets/item_card2.dart';

class HomeSceeen extends StatefulWidget {
  const HomeSceeen({super.key});

  @override
  State<HomeSceeen> createState() => _HomeSceeenState();
}

class _HomeSceeenState extends State<HomeSceeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // TODO: 1. Buat appbar dengan judul Wisata Candi
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white10,
          title: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(8),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()));
                },
              ),
            ),
          ],
        ),

        // TODO: 2. Buat Body dengan GridView.builder
        body: Body());
  }
}
