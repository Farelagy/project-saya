import 'package:flutter/material.dart';
import 'package:flutter_learning2/pages/cartpage.dart';
import 'package:flutter_learning2/pages/product_detail.dart';
import 'package:flutter_learning2/pages/profilepage.dart';
import 'package:flutter_learning2/pages/searchpage.dart';
import 'package:flutter_learning2/pages/cartpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

//menambahkan notes untuk iseng masuk ke branch

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomePageContent(),
    const Searchpage(),
    const CartPage(),
    const Profilepage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey.shade400,
                showUnselectedLabels: true,
                backgroundColor: Colors.black,
                type: BottomNavigationBarType.fixed,
                iconSize: 20,
                selectedFontSize: 12,
                unselectedFontSize: 10,
                onTap: _onItemTapped,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: "Search",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    label: "Cart",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String selectedCategory = "RAYS";
  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredProducts();
  }

  void _updateFilteredProducts() {
    setState(() {
      filteredProducts =
          products
              .where((product) => product["category"] == selectedCategory)
              .toList();
    });
  }

  Future<String> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fullName') ?? "User";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            FutureBuilder<String>(
              future: _getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    "Loading...",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                }
                return Text(
                  "Welcome Back, ${snapshot.data ?? "User"}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 2),
            const Text(
              "Velg apa yang kamu sedang cari?",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    [
                      "RAYS",
                      "ENKEI",
                      "BRAID",
                    ].map((category) => _categoryButton(category)).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  filteredProducts.isNotEmpty
                      ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.75,
                            ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(filteredProducts[index]);
                        },
                      )
                      : const Center(
                        child: Text(
                          "Tidak ada produk untuk kategori ini.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryButton(String title) {
    bool isSelected = title == selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
          _updateFilteredProducts();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF28C28) : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: Colors.black),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                product["image"],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 140,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 140,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product["name"],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "\$${product["price"]}",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> products = [
  {
    "name": "Rays CE28N",
    "price": 256.00,
    "image": "assets/images/CE28N.png",
    "category": "RAYS",
  },
  {
    "name": "Rays G025",
    "price": 284.00,
    "image": "assets/images/G025.png",
    "category": "RAYS",
  },
  {
    "name": "Rays TE37XT SL",
    "price": 264.00,
    "image": "assets/images/TE37_XT_SL.png",
    "category": "RAYS",
  },
  {
    "name": "Rays ZE40",
    "price": 232.00,
    "image": "assets/images/ZE40.png",
    "category": "RAYS",
  },
  {
    "name": "Enkei RPF1",
    "price": 210.00,
    "image": "assets/images/ENKEI_RPF.png",
    "category": "ENKEI",
  },
  {
    "name": "Enkei NT03",
    "price": 220.00,
    "image": "assets/images/NT03.png",
    "category": "ENKEI",
  },
  {
    "name": "Braid Winrace",
    "price": 290.00,
    "image": "assets/images/BRAID_WINRACE.png",
    "category": "BRAID",
  },
  {
    "name": "Braid Fullrace",
    "price": 310.00,
    "image": "assets/images/BRAID_FULLRACE.png",
    "category": "BRAID",
  },
];
