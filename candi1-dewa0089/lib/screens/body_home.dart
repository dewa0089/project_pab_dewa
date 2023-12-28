import 'package:flutter/material.dart';
// import 'package:shoes_shop/animation/fadeanimation.dart';
import 'package:shoes_shop/data/shoes.dart';
import 'package:shoes_shop/model/shoes.dart';
import 'package:shoes_shop/screens/detail_screen.dart';
import 'package:shoes_shop/widgets/item_card.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String selectedCategory = 'All'; // Default category is 'All'
  int selectedIndexOfCategory = 0;
  int selectedIndexOfFeatured = 1;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            topCategoriesWidget(width, height),
            SizedBox(height: 10),
            middleCategoriesWidget(width, height),
            SizedBox(height: 5),
            moreTextWidget(),
            lastCategoriesWidget(width, height),
          ],
        ),
      ),
    );
  }

// Top Categories Widget Components
  topCategoriesWidget(width, height) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: width,
          height: height / 18,
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: categories.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = 'All';
                        selectedIndexOfCategory = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedIndexOfCategory == 0
                                ? Colors.black
                                : Colors.white,
                            width: 1.5,
                          ),
                          color: selectedIndexOfCategory == 0
                              ? Colors.black
                              : Colors.white,
                        ),
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontSize: selectedIndexOfCategory == 0 ? 21 : 18,
                            color: selectedIndexOfCategory == 0
                                ? Colors.white
                                : Colors.black,
                            fontWeight: selectedIndexOfCategory == 0
                                ? FontWeight.normal
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                final category = categories[index - 1];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      selectedIndexOfCategory = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedIndexOfCategory == index
                              ? Colors.black
                              : Colors.white,
                          width: 1.5,
                        ),
                        color: selectedIndexOfCategory == index
                            ? Colors.black
                            : Colors.white,
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: selectedIndexOfCategory == index ? 21 : 18,
                          color: selectedIndexOfCategory == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: selectedIndexOfCategory == index
                              ? FontWeight.normal
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

// Middle Categories Widget Components
  middleCategoriesWidget(width, height) {
    final filteredShoesList = selectedCategory == 'All'
        ? shoesList
        : shoesList
            .where((shoes) => shoes.category == selectedCategory)
            .toList();
    return Row(
      children: [
        Container(
          width: width / 1.2,
          height: height / 2.4,
          margin: EdgeInsets.only(left: 25),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: filteredShoesList.length,
            itemBuilder: (ctx, index) {
              Shoes shoes = filteredShoesList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => DetailScreen(
                        shoes: shoes,
                        // isComeFromMoreSection: false,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: width / 1.5,
                  child: Stack(
                    children: [
                      Container(
                        width: width / 1.81,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      Positioned(
                        left: 22,
                        top: 15,
                        child: Container(
                          child: Row(
                            children: [
                              Text(
                                shoes.name,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              SizedBox(
                                width: 90,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 21,
                        child: Container(
                          child: Text(
                            shoes.model,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 33,
                        left: 33,
                        child: Container(
                          child: Text(
                            "\$${shoes.price.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 50,
                        child: Container(
                          child: Hero(
                            tag: 'middle_${shoes.imageAsset}',
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation(-20 / 360),
                              child: Container(
                                width: 200,
                                height: 270,
                                child: Image(
                                  image: AssetImage(shoes.imageAsset),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

// More Text Widget Components
  moreTextWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text("More",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          Expanded(child: Container()),
          Icon(
            Icons.arrow_downward,
            size: 35,
          )
        ],
      ),
    );
  }

// Last Categories Widget Components
  lastCategoriesWidget(width, height) {
    return Container(
      width: width,
      height: height / 3,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          padding: const EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          itemCount: shoesList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (ctx, index) {
            Shoes shoes = shoesList[index];
            return ItemCard(shoes: shoes);
          }),
    );
  }
}
