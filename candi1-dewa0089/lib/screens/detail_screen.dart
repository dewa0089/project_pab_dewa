import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_shop/data/shoes.dart';
import 'package:shoes_shop/model/shoes.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.shoes});
  final Shoes shoes;

  @override
  State<DetailScreen> createState() => _DetailScreenState(shoes: shoes);
}

//TODO: 1 Implementasi sisa dari DetailScreen
class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState({required this.shoes});
  final Shoes shoes;
  bool isFavorite = false;
  bool isSignIn = false; // Menyimpan status sign in
  int? _isSelectedSize;
  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
    _loadFavoriteStatus();
  }

//Memeriksa status sign in
  void _checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool signedIn = prefs.getBool('isSignedIn') ?? false;
    setState(() {
      isSignIn = signedIn;
    });
  }

  // Memeriksa status favorite
  void _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool favorite = prefs.getBool('favorite_${widget.shoes.id}') ?? false;
    setState(() {
      isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!isSignIn) {
      //jika belum sign in, diarahkan ke Sign In Screen
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, '/signin');
      });
      return;
    }

    bool favoriteStatus = !isFavorite;
    prefs.setBool('favorite_${widget.shoes.id}', favoriteStatus);
    // Tambahkan pemanggilan untuk memperbarui tampilan Favorit
    _loadFavoriteStatus();

    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45, left: 22, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {
                          _toggleFavorite();
                        },
                        icon: Icon(
                          isSignIn && isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isSignIn && isFavorite ? Colors.red : null,
                          size: 30,
                        )),
                  ],
                ),
              ),
            ],
          ),
          Container(
            child: Column(
              children: [
                Hero(
                  tag: widget.shoes.imageAsset,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Container(
                      // borderRadius: BorderRadius.circular(20),
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation(-18 / 360),
                        child: Image.asset(
                          widget.shoes.imageAsset,
                          // width: double.infinity,
                          height: 100,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          //Detail Info
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${widget.shoes.price.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 32,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(shoes.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 16,
                ),
                Divider(
                  color: const Color.fromARGB(255, 14, 14, 16),
                ),
                SizedBox(
                  width: 16,
                  height: 10,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'BUY  SHOES',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          shoes.model,
                          style: TextStyle(color: Colors.grey, fontSize: 30),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Ukuran Sepatu Yang tersedia :',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSelectedSize = index;
                                });
                              },
                              child: Container(
                                width: 60,
                                margin: EdgeInsets.only(right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: _isSelectedSize == index
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 1.5),
                                  color: _isSelectedSize == index
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    sizes[index].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _isSelectedSize == index
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Deskripsi Sepatu :',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          shoes.description,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //Detail Galery
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        color: Colors.red,
                        size: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Palembang',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: Colors.black,
                        size: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '18.00 - 22.00',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  )
                ],
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
