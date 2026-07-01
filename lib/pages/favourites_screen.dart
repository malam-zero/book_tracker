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
              itemCount: favBooks.length,
              itemBuilder: (context, index) {
                Book book = favBooks[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      book.imageLinks['thumbnail'] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.book),
                    ),
                    title: Text(book.title),
                    subtitle: Text(book.authors.join(', ')),
                    trailing: const Icon(Icons.favorite, color: Colors.red),
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
