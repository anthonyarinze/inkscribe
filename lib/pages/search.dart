import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'book_details.dart';
import 'package:shimmer/shimmer.dart';

import '../components/search_bar.dart';
import '../components/page_builder.dart';
import '../components/book_card.dart';
import '../components/skeleton_book_card.dart';
import '../utils/dio_manager/dio_manager.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? apiKey = dotenv.env["API_KEY"];
  String? baseUrl = dotenv.env["BASE_URL"];
  String? bodyUrl = dotenv.env["BODY_URL"];
  String? fallbackUrl = dotenv.env["FALLBACK_URL"];
  TextEditingController textEditingController = TextEditingController();
  late Future _future;

  void updateSearch(String searchQuery) {
    setState(() {
      _future = _fetchBooks(searchQuery);
    });
  }

  Future _fetchBooks(String searchQuery) async {
    final response = await DioManager().get("$baseUrl$searchQuery$bodyUrl$apiKey");

    return response;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'InkScribe',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchPageSearchBar(
              textEditingController: textEditingController,
              onSubmitted: updateSearch,
            ),
            textEditingController.text.length > 1
                ? FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
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
                        return Text("Encountered an error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: data['items'].length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            final volumeInfo = data['items'][index]['volumeInfo'];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                ZoomPageRoute(page: const BookDetails()),
                              ),
                              child: BookCard(
                                imageUrl: volumeInfo['imageLinks']['thumbnail'] ?? fallbackUrl,
                                title: volumeInfo['title'] ?? "N/A",
                                author: volumeInfo['authors'] != null && volumeInfo['authors'].isNotEmpty ? "By ${volumeInfo['authors'][0]}" : "N/A",
                              ),
                            );
                          },
                        );
                      } else {
                        return Text(
                          'No results found for "${textEditingController.text}"',
                          style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Go ahead and search for a book.',
                      style: GoogleFonts.roboto(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
