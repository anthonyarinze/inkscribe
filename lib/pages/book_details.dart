import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/components/add_comment_dialog.dart';
import 'package:inkscribe/components/skeleton_comment.dart';
import 'package:inkscribe/models/comment.dart';
import 'package:inkscribe/theme/palette.dart';
import 'package:inkscribe/utils/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../components/expandable_note_widget.dart';

class BookDetails extends StatefulWidget {
  final String title, author, synopsis, image, id;
  const BookDetails({
    super.key,
    required this.title,
    required this.author,
    required this.synopsis,
    required this.image,
    required this.id,
  });

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              widget.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(context: context, builder: (context) => AddCommentDialog(title: widget.title, color: Colors.red)),
        shape: const CircleBorder(),
        backgroundColor: Palette.primePurple,
        child: const Icon(Icons.add, size: 32.0, color: Colors.white),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width,
              height: 250.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Image section
                  Container(
                    height: 220.0,
                    width: 180.0,
                    decoration: BoxDecoration(
                      // color: Colors.red,
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
                        image: NetworkImage(widget.image),
                      ),
                    ),
                  ),
                  // Details section
                  SizedBox(
                    height: 220.0,
                    width: 180.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.author,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Text(
                "Synopsis",
                style: GoogleFonts.roboto(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SelectableText(
                widget.synopsis,
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 20.0, bottom: 18.0),
              child: SelectableText(
                "Your Comments",
                style: GoogleFonts.roboto(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StreamBuilder<Object>(
              stream: AuthServices().commentsStream(widget.id),
              builder: (context, snapshot) {
                return FutureBuilder<List<Comment>>(
                  future: AuthServices().getCommentsForBook(widget.title),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        child: const SkeletonComment(),
                      );
                    } else if (snapshot.hasError) {
                      return SelectableText('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final List<Comment> comments = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final userComments = comments[index];

                          // Convert the Firebase timestamp to a millisecond value.
                          final millisecondsSinceEpoch = userComments.timestamp.millisecondsSinceEpoch;

                          // Create a new DateTime object from the millisecond value.
                          final dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
                          final dateFormattedDateTime = DateFormat('dd MMMM, yyyy').format(dateTime);
                          final timeFormattedDateTime = DateFormat('hh:mm a').format(dateTime);
                          return Dismissible(
                            key: Key(userComments.id),
                            child: ExpandableNoteWidget(
                              userComments: userComments,
                              timeFormattedDateTime: timeFormattedDateTime,
                              dateFormattedDateTime: dateFormattedDateTime,
                              color: Color(userComments.color),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                AuthServices().deleteComment(widget.title, userComments.id);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Deleted '${userComments.title}' "),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return const Text('No comments available for this book.');
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
