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
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Book book = snapshot.data![index];
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
                    child: InkWell(
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
                          title: Text(
                            book.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            onPressed: () async {
                              await DatabaseHelper.instance.deleteBook(book.id);
                              _refreshBooks();
                            },
                          ),
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.authors.join(', '),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 32,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: book.isFavorite
                                        ? Colors.red[50]
                                        : Colors.grey[100],
                                    foregroundColor: book.isFavorite
                                        ? Colors.red
                                        : Colors.black87,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  ),
                                  onPressed: () async {
                                    book.isFavorite = !book.isFavorite;
                                    await DatabaseHelper.instance
                                        .toggleFavoriteStatus(
                                          book.id,
                                          book.isFavorite,
                                        );
                                    _refreshBooks();
                                  },
                                  icon: Icon(
                                    book.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    size: 16,
                                    color: book.isFavorite ? Colors.red : null,
                                  ),
                                  label: Text(
                                    (book.isFavorite)
                                        ? 'Favorite'
                                        : 'Add to Favorites',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
