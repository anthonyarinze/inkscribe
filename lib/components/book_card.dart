import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/providers/theme_provier.dart';
import 'package:inkscribe/theme/palette.dart';
import 'package:inkscribe/utils/auth_service.dart';
import 'package:inkscribe/utils/functions.dart';

import 'dialog_card.dart';

class BookCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String id;
  final String synopsis;
  final bool isHomePage;
  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.id,
    required this.isHomePage,
    required this.synopsis,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isBookmarked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.0,
      width: 180.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(4.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.imageUrl),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 118.0,
            top: 8.0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isBookmarked = !isBookmarked;
                });
                if (isBookmarked) {
                  try {
                    AuthServices().addToCollection(
                      widget.title,
                      widget.imageUrl,
                      widget.author,
                      widget.id,
                      widget.synopsis,
                    );
                  } on FirebaseException catch (error) {
                    ReusableFunctions.logError(error.message);
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialogBox(
                        title: "Error",
                        descriptions: error.message.toString(),
                        text: "Close",
                      ),
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${widget.title} added to your collection."),
                    ),
                  );
                } else {
                  try {
                    AuthServices().removeFromCollection(widget.title, widget.id);
                  } on FirebaseException catch (error) {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialogBox(
                        title: "Error",
                        descriptions: error.message.toString(),
                        text: "Close",
                      ),
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${widget.title} removed from your collection."),
                    ),
                  );
                }
              },
              child: Visibility(
                visible: !widget.isHomePage,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.bounceInOut,
                  switchOutCurve: Curves.bounceOut,
                  child: isBookmarked
                      ? Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFf2f7ff),
                            border: Border.all(
                              color: Palette.darkThemeBackground,
                              width: 3.0,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.bookmark_rounded,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFf2f7ff),
                            border: Border.all(
                              color: Palette.darkThemeBackground,
                              width: 1.0,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.bookmark_add_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final themeModeState = ref.watch(themesProvider);
                  return Container(
                    height: 60,
                    width: 180.0,
                    decoration: BoxDecoration(
                      color: themeModeState == ThemeMode.light ? Colors.white : Palette.darkThemeBackground,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(4.0),
                        bottomRight: Radius.circular(4.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontSize: 12.0,
                              color: themeModeState == ThemeMode.light ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontSize: 13.0,
                              color: themeModeState == ThemeMode.light ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
