import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/components/book_card.dart';
import 'package:inkscribe/components/page_builders/book_details_builder.dart';
import 'package:inkscribe/components/skeleton_book_card.dart';
import 'package:inkscribe/utils/auth_service.dart';
import 'package:inkscribe/utils/functions.dart';
import 'package:shimmer/shimmer.dart';

import 'book_details.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<List<BookCard>> fetchBooksFromDatabase() async {
    final response = await AuthServices().getBooksFromFirestore();

    return response;
  }

  bool isBottomSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<String?>(
                future: ReusableFunctions().getCachedUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Loading state
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data != null) {
                    // Display the welcome message
                    final username = snapshot.data!;
                    return Text(
                      'Hi $username!',
                      style: GoogleFonts.playfairDisplay(fontSize: 24.0, fontWeight: FontWeight.bold),
                    );
                  } else {
                    // No cached username
                    return Text(
                      'Welcome!',
                      style: GoogleFonts.playfairDisplay(fontSize: 24.0, fontWeight: FontWeight.bold),
                    );
                  }
                },
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined, size: 28.0),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Divider(
                indent: 20.0,
                endIndent: 20.0,
              ),
            ),
            StreamBuilder<Object>(
                stream: AuthServices().bookmarkStream(),
                builder: (context, snapshot) {
                  return FutureBuilder<List<BookCard>>(
                    future: fetchBooksFromDatabase(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return GridView.builder(
                          itemCount: 2,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) => Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white,
                            child: const SkeletonBookCard(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final List<BookCard> books = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: books.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                bookDetailsPageBuilder(
                                  BookDetails(
                                    title: book.title,
                                    author: book.author,
                                    synopsis: book.synopsis,
                                    image: book.imageUrl,
                                    id: book.id,
                                  ),
                                ),
                              ),
                              onLongPress: () => showOptionsBottomSheet(
                                context,
                                book.title,
                                book.id,
                                book.author,
                                book.synopsis,
                                book.imageUrl,
                              ),
                              child: BookCard(
                                imageUrl: book.imageUrl,
                                title: book.title,
                                author: book.author,
                                id: book.id,
                                synopsis: book.synopsis,
                                isHomePage: true,
                              ),
                            );
                          },
                        );
                      } else {
                        return const Text('No books found.');
                      }
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }

  void showOptionsBottomSheet(BuildContext context, String title, String id, String author, String synopsis, String image) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('Open Book'),
              onTap: () {
                Navigator.push(
                  context,
                  bookDetailsPageBuilder(
                    BookDetails(
                      title: title,
                      author: author,
                      synopsis: synopsis,
                      image: image,
                      id: id,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove Bookmark'),
              onTap: () {
                AuthServices().removeFromCollection(title, id);
                fetchBooksFromDatabase();
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
          ],
        );
      },
    );
  }
}
