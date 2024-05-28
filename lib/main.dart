import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    BrowseCategories(),
    Text('Search Page'),
    Text('Favorites Page'),
    Text('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Browse Categories')),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class BrowseCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              'BROWSE CATEGORIES',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              'Not sure about exactly which recipe you\'re looking for? Do a search, or dive into our most popular categories.',
              textAlign: TextAlign.center,
            ),
          ),
          CategoryRow(
            title: 'BY MEAT',
            images: ['beef-image.jpeg', 'chicken.png', 'pork.png', 'seafood.jpeg'],
            labels: ['BEEF', 'CHICKEN', 'PORK', 'SEAFOOD'],
            textAlignment: Alignment.center,
          ),
          CategoryRow(
            title: 'BY COURSE',
            images: ['main-foods.jpeg', 'salad.jpeg', 'Side-Dishes.png', 'crockpot.png'],
            labels: ['Main Dishes', 'Salad Recipes', 'Side Dishes', 'Crockpot'],
            textAlignment: Alignment.bottomCenter,
          ),
          CategoryRow(
            title: 'BY DESSERT',
            images: ['ice-cream.jpg', 'brownies.jpg', 'pies.jpg', 'cookies.jpg'],
            labels: ['Ice Cream', 'Brownies', 'Pies', 'Cookies'],
            textAlignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}

class CategoryRow extends StatelessWidget {
  final String title;
  final List<String> images;
  final List<String> labels;
  final Alignment textAlignment;

  CategoryRow({required this.title, required this.images, required this.labels, required this.textAlignment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(images.length, (index) {
            return Stack(
              alignment: textAlignment,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/${images[index]}'),
                  radius: 40,
                ),
                Positioned(
                  bottom: textAlignment == Alignment.bottomCenter ? 8 : null,
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
