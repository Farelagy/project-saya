import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_learning2/pages/wishlist_provider.dart'; // ✅ Pastikan path benar

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isAddedToCart = false;
  String selectedSize = 'L';

  void addToCart() {
    setState(() {
      isAddedToCart = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isAddedToCart = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final isInWishlist = wishlistProvider.isInWishlist(product);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border,
              color: Colors.black,
            ),
            onPressed: () {
              if (isInWishlist) {
                wishlistProvider.removeFromWishlist(product);
              } else {
                wishlistProvider.addToWishlist(product);
              }
              setState(() {}); // Untuk update ikon
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                product["image"],
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Nama & Warna
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    product["name"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: const [
                    CircleAvatar(backgroundColor: Colors.brown, radius: 8),
                    SizedBox(width: 5),
                    CircleAvatar(backgroundColor: Colors.black, radius: 8),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Size
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Size", style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children:
                  ['17', '18', '19', '20'].map((size) {
                    final isSelected = selectedSize == size;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => selectedSize = size);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Deskripsi produk
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              product["description"] ?? "No description available.",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Spacer(),

          // Harga & Tombol Add to Cart
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  "\$${product["price"]}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF28C28),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Add To Cart",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
