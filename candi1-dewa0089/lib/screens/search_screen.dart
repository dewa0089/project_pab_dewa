import 'package:flutter/material.dart';
import 'package:shoes_shop/data/shoes.dart';
import 'package:shoes_shop/model/shoes.dart';
import 'package:shoes_shop/widgets/item_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Shoes> _filteredShoes = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi hasil filter dengan seluruh data
    _filteredShoes = shoesList;
  }

  // Fungsi untuk melakukan filter berdasarkan teks yang dimasukkan
  void filterSearchResults(String query) {
    List<Shoes> searchList = [];
    searchList.addAll(shoesList);

    if (query.isNotEmpty) {
      List<Shoes> resultData = [];
      searchList.forEach((shoes) {
        if (shoes.name.toLowerCase().contains(query.toLowerCase()) ||
            shoes.model.toLowerCase().contains(query.toLowerCase())) {
          resultData.add(shoes);
        }
      });
      setState(() {
        _filteredShoes = resultData;
      });
      return;
    } else {
      setState(() {
        _filteredShoes = shoesList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Your Shoes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.deepPurple[50],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  // Panggil fungsi filter setiap kali nilai diubah
                  filterSearchResults(value);
                },
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search Shoes',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _filteredShoes.length,
              itemBuilder: (context, index) {
                final shoes = _filteredShoes[index];
                return ItemCard(
                  shoes: shoes,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
