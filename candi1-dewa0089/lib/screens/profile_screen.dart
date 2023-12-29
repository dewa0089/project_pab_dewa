import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_shop/data/shoes.dart';
import 'package:shoes_shop/model/shoes.dart';
import 'package:shoes_shop/widgets/profil_info_item.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _fullNameController = TextEditingController();
  // TODO: 1 Deklarasikan variabel yang dibutuhkan
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  int favoriteCandiCount = 0;

  Future<int> _calculateFavoriteCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = 0;
    prefs.getKeys().forEach((key) {
      if (key.startsWith('favorite_') && prefs.getBool(key) == true) {
        count++;
      }
    });
    return count;
  }

  // TODO: 5 Implementasi fungsi signIn
  void signIn() {
    // setState(() {
    //   isSignedIn = !isSignedIn;
    // });
    Navigator.pushNamed(context, "/signin");
  }

  // TODO: 6 Implementasi fungsi signOut
  void signOut() async {
    // setState(() {
    //   isSignedIn = !isSignedIn;
    // });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', '');
    prefs.setString('username', '');
    prefs.setString('password', '');
    prefs.setBool('isSignedIn', false);
    prefs.remove('key');
    prefs.remove('iv');
    setState(() {
      fullName = '';
      userName = '';
      isSignedIn = false;
    });
  }

  void editFullName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';
    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    dynamic encryptedFullName = prefs.getString('name') ?? '';
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decryptedFullName = encrypter.decrypt64(encryptedFullName, iv: iv);

    // Mengatur nilai awal controller dengan nama yang sebelumnya terdekripsi
    _fullNameController.text = decryptedFullName;

    // Menampilkan dialog atau modal untuk mengedit nama
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Full Name'),
          content: TextField(
            controller: _fullNameController,
            decoration: InputDecoration(labelText: 'Full Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Enkripsi nama yang baru
                encryptedFullName =
                    encrypter.encrypt(_fullNameController.text, iv: iv);
                // Simpan nama terenkripsi ke SharedPreferences
                prefs.setString('name', encryptedFullName.base64);
                // Perbarui state dengan nama yang baru
                setState(() {
                  fullName = _fullNameController.text;
                });
                Navigator.pop(context); // Tutup dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setNameAndUsername();
    setImageFilePath();
  }

  void setNameAndUsername() async {
    try {
      final Future<SharedPreferences> prefsFuture =
          SharedPreferences.getInstance();
      final SharedPreferences prefs = await prefsFuture;
      final data = _retrieveAndDecryptDataFromPrefs(prefs);
      if (data.isNotEmpty) {
        final decryptedUsername = data['username'];
        final decryptedName = data['name'];
        final favoriteCount = await _calculateFavoriteCount();
        setState(() {
          fullName = decryptedName;
          userName = decryptedUsername;
          isSignedIn = true;
          favoriteCandiCount = favoriteCount;
        });
      }
    } catch (e) {
      print("Print error $e");
    }
  }

  _retrieveAndDecryptDataFromPrefs(
    SharedPreferences prefs,
  ) {
    final sharedPreferences = prefs;
    final encryptedUsername = sharedPreferences.getString('username') ?? '';
    final encryptedName = sharedPreferences.getString('name') ?? '';
    final keyString = sharedPreferences.getString('key') ?? '';
    final ivString = sharedPreferences.getString('iv') ?? '';

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
    final decryptedName = encrypter.decrypt64(encryptedName, iv: iv);

    return {'username': decryptedUsername, 'name': decryptedName};
  }

  String _imageFile = '';
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Sumber Gambar'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                child: Text('Galeri'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, ImageSource.camera),
                child: Text('Kamera'),
              ),
            ],
          ),
        );
      },
    );

    if (imageSource != null) {
      final pickedFile = await picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile.path;
        });
        saveImageFilePath(_imageFile); // Simpan path gambar
        Shoes shoes = shoesList.firstWhere((shoes) => shoes.id == shoesList);
        // Tambahkan item ke favorit
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('favorite_${shoes.id}', true);

        // Perbarui hitungan favorit
        final favoriteCount = await _calculateFavoriteCount();
        setState(() {
          favoriteCandiCount = favoriteCount;
        });
      }
    }
  }

  void saveImageFilePath(String filePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imagePath', filePath);
  }

  void setImageFilePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('imagePath') ?? '';
    setState(() {
      _imageFile = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: 190,
            width: double.infinity,
            color: Colors.blue,
            child: Center(
              child: Text(
                'PROFILE',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // TODO: 2 Buat bagian ProfileHeader yang berisi gambar profil
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 190 - 50),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: _imageFile.isEmpty
                                ? AssetImage('images/placeholder_image.png')
                                    as ImageProvider<Object>
                                : FileImage(File(_imageFile))
                                    as ImageProvider<Object>,
                          ),
                        ),
                        if (isSignedIn)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                              onPressed: _getImage,
                              icon: Icon(Icons.camera_alt,
                                  color: Colors.deepPurple[50]),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // TODO: 3 Buat bagian ProfileInfo yang berisi info profil

                // Pengguna
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.deepPurple[100],
                ),
                SizedBox(
                  height: 4,
                ),
                ProfilInfoItem(
                  icon: Icons.lock,
                  label: "Pengguna",
                  value: userName,
                  iconColor: Colors.amber,
                ),

                // Nama
                SizedBox(
                  height: 4,
                ),
                Divider(
                  color: Colors.deepPurple[100],
                ),
                SizedBox(
                  height: 4,
                ),
                ProfilInfoItem(
                  icon: Icons.person,
                  label: "Nama",
                  value: fullName,
                  iconColor: Colors.blue,
                  showEdition: isSignedIn,
                  onEditPressed: editFullName,
                ),

                //Favorit
                SizedBox(
                  height: 4,
                ),
                Divider(
                  color: Colors.deepPurple[100],
                ),
                SizedBox(
                  height: 4,
                ),
                ProfilInfoItem(
                  icon: Icons.favorite,
                  label: "Favorit",
                  value: "$favoriteCandiCount",
                  iconColor: Colors.red,
                ),

                //Penutup
                SizedBox(
                  height: 4,
                ),
                Divider(
                  color: Colors.deepPurple[100],
                ),
                SizedBox(
                  height: 20,
                ),
                // TODO: 4 Buat ProfileAction yang berisi TextButton sign in/sign out
                isSignedIn
                    ? ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: signOut,
                            style: ElevatedButton.styleFrom(
                              primary: Colors
                                  .red, // Ubah warna latar belakang sesuai kebutuhan
                              fixedSize: Size(200, 40),
                            ),
                            child: Text(
                              "Sign Out",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    : ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: signIn,
                            style: ElevatedButton.styleFrom(
                              primary: Colors
                                  .green, // Ubah warna latar belakang sesuai kebutuhan
                              fixedSize: Size(200, 40),
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
