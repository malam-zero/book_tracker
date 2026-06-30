
import 'package:book_tracker/models/book_model.dart';

class BookDetailsArguments {
  final Book itemBook;
  final bool isFromSavedScreen;

  BookDetailsArguments({
    required this.itemBook,
    required this.isFromSavedScreen,
  });
}
