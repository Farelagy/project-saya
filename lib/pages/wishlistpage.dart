import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_learning2/pages/wishlist_provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlist = wishlistProvider.wishlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body:
          wishlist.isEmpty
              ? const Center(
                child: Text(
                  'Wishlist kamu masih kosong 😢',
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: wishlist.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final product = wishlist[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          product['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        product['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("\$${product['price']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          wishlistProvider.removeFromWishlist(product);
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
