import 'package:book_tracker/db/database_helper.dart';
import 'package:book_tracker/models/book_model.dart';
import 'package:flutter/material.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late Future<List<Book>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = DatabaseHelper.instance.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          // print("OGj:: ${snapshot.data?.first}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Book> favBooks = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favBooks.length,
              itemBuilder: (context, index) {
                Book book = favBooks[index];
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          book.imageLinks['thumbnail'] ?? '',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 75,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.book, size: 50),
                        ),
                      ),
                      title: Text(
                        book.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        book.authors.join(', '),
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      trailing: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No favorite books found'));
          }
        },
      ),
    );
  }
}
