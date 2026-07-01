import 'package:book_tracker/db/database_helper.dart';
import 'package:book_tracker/models/book_model.dart';
import 'package:book_tracker/utils/book_details_argument.dart';
import 'package:flutter/material.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as BookDetailsArguments;
    final Book book = args.itemBook;
    final bool isFromSavedScreen = args.isFromSavedScreen;

    final theme = Theme.of(context).textTheme;

    late Future<List<Book>> booksFuture;
    void refreshBooks() {
      setState(() {
        booksFuture = DatabaseHelper.instance.readAllBooks();
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              if (book.imageLinks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    book.imageLinks['thumbnail'] ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(book.title, style: theme.headlineSmall),
                  Text(book.authors.join(', '), style: theme.labelLarge),
                  Text(
                    'Published: ${book.publishedDate}',
                    style: theme.bodySmall,
                  ),
                  Text('Page count: ${book.pageCount}', style: theme.bodySmall),
                  Text('Language: ${book.language}', style: theme.bodySmall),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: !isFromSavedScreen
                        ? ElevatedButton(
                            onPressed: () async {
                              try {
                                await DatabaseHelper.instance.insert(book);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Book Saved")),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error saving book: $e")),
                                  );
                                }
                              }
                            },
                            child: const Text('Save'),
                          )
                        : ElevatedButton.icon(
                            onPressed: () async {
                              book.isFavorite = !book.isFavorite;
                              await DatabaseHelper.instance
                                  .toggleFavoriteStatus(
                                    book.id,
                                    book.isFavorite,
                                  );
                              refreshBooks();
                            },
                            icon: const Icon(Icons.favorite),
                            label: const Text('Favorite'),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Text('Description', style: theme.titleMedium),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: Text(book.description),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
