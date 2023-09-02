import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/components/book_card.dart';
import 'package:inkscribe/providers/index_provider.dart';
import 'package:inkscribe/utils/auth_service.dart';
import 'package:inkscribe/utils/functions.dart';

import '../components/page_builder.dart';
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
                indent: 30.0,
                endIndent: 30.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                "A whole world of books awaits you! Add something to your library to get started.",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        Icon(Icons.book, size: 28.0),
                        Text('Explore the book store'),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),
            FutureBuilder<List<BookCard>>(
              future: fetchBooksFromDatabase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
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
                          ZoomPageRoute(page: const BookDetails()),
                        ),
                        child: BookCard(
                          imageUrl: book.imageUrl,
                          title: book.title,
                          author: book.author,
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('No books found.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
