import 'package:book_tracker/db/database_helper.dart';
import 'package:book_tracker/models/book_model.dart';
import 'package:book_tracker/utils/book_details_argument.dart';
import 'package:flutter/material.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = DatabaseHelper.instance.readAllBooks();
  }

  void _refreshBooks() {
    setState(() {
      _booksFuture = DatabaseHelper.instance.readAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _booksFuture,
        builder: (context, snapshot) => snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Book book = snapshot.data![index];
                  // get each books fav status

                  //print("Books: ==> ${snapshot.data![index].toString()}");
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: BookDetailsArguments(
                          itemBook: book,
                          isFromSavedScreen: true,
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(book.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DatabaseHelper.instance.deleteBook(book.id);
                            _refreshBooks();
                          },
                        ),
                        leading: Image.network(
                          book.imageLinks['thumbnail'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.book),
                        ),
                        subtitle: Column(
                          children: [
                            Text(book.authors.join(', ')),
                            ElevatedButton.icon(
                              onPressed: () async {
                                // toggle the favorite flag
                                book.isFavorite = !book.isFavorite;
                                await DatabaseHelper.instance
                                    .toggleFavoriteStatus(
                                      book.id,
                                      book.isFavorite,
                                    );
                                //refresh th UI
                                _refreshBooks();
                              },
                              icon: Icon(
                                book.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color: book.isFavorite ? Colors.red : null,
                              ),
                              label: Text(
                                (book.isFavorite)
                                    ? 'Favorite'
                                    : 'Add to Favorites',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
