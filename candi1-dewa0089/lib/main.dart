import 'package:flutter/material.dart';
import 'package:shoes_shop/screens/favorite_screen.dart';
import 'package:shoes_shop/screens/home_screen.dart';
import 'package:shoes_shop/screens/profile_screen.dart';
import 'package:shoes_shop/screens/sign_in_screen.dart';
import 'package:shoes_shop/screens/sign_up_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoes Shop',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          primary: Colors.deepPurple,
          surface: Colors.deepPurple[50],
        ),
        useMaterial3: true,
      ),
      // home: const MainSreen(),
      home: MainScreen(),
      initialRoute: '/',
      routes: {
        '/homescreen': (context) => const HomeSceeen(),
        '/favorite': (context) => FavoriteScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //TODO: 1 Deklarasikan variable
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomeSceeen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO:  2 Buat properti body berupa widget yang ditampilkan
      body: _children[_currentIndex],
      //TODO: 3 Buat properti bottomNavigasiBar dengan nilai Theme
      bottomNavigationBar: Theme(
        //TODO: 4 Buat data dan child dari Theme
        data: Theme.of(context).copyWith(canvasColor: Colors.deepPurple[50]),
        child: Container(
          child: BottomNavigationBar(
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.deepPurple[100],
              showSelectedLabels: true,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                //Home
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home',
                ),
                //Search
                // BottomNavigationBarItem(
                //   icon: Icon(
                //     Icons.search,
                //     color: Colors.deepPurple,
                //   ),
                //   label: 'Pencarian',
                // ),
                //Favorite
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                  ),
                  label: 'Favorite',
                ),
                //Profile
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: 'Profile',
                )
              ]),
        ),
      ),
    );
  }
}
