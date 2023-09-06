import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/components/add_comment_dialog.dart';
import 'package:inkscribe/theme/palette.dart';
import 'package:inkscribe/utils/auth_service.dart';

class BookDetails extends StatelessWidget {
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
              title,
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
        onPressed: () => showDialog(context: context, builder: (context) => AddCommentDialog(title: title)),
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
                      color: Colors.red,
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
                        image: NetworkImage(image),
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
                          title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          author,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(0.45),
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
                synopsis,
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: SelectableText(
                "Your Comments",
                style: GoogleFonts.roboto(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => AuthServices().addCommentToBook(title, 'Initial Comment'),
              child: const Text('Send'),
            ),
            StreamBuilder<Object>(
                stream: AuthServices().commentsStream(title),
                builder: (context, snapshot) {
                  return FutureBuilder<List<String>>(
                    future: AuthServices().getCommentsForBook(title),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final List<String> comments = snapshot.data!;
                        if (comments.isEmpty) {
                          return const Text('No comments available for this book.');
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return ListTile(
                              title: Text(comment),
                            );
                          },
                        );
                      } else {
                        return const Text('No comments available for this book.');
                      }
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
