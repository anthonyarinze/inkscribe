import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/utils/auth_service.dart';

class BookCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String id;
  final bool isHomePage;
  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.id,
    required this.isHomePage,
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
                  AuthServices().addToCollection(
                    widget.title,
                    widget.imageUrl,
                    widget.author,
                    widget.id,
                  );
                } else {
                  AuthServices().removeFromCollection(widget.title, widget.id);
                }
              },
              child: Visibility(
                visible: !widget.isHomePage,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isBookmarked
                      ? Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFf2f7ff),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.bookmark_rounded,
                            ),
                          ),
                        )
                      : Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFf2f7ff),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.bookmark_add_outlined,
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
              Container(
                height: 60,
                width: 180.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
