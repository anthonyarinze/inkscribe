// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPageSearchBar extends StatelessWidget {
  const SearchPageSearchBar({
    Key? key,
    required this.textEditingController,
    required this.onSubmitted,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Material(
        elevation: 1.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: TextField(
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
            controller: textEditingController,
            onSubmitted: onSubmitted,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search for a book...",
              fillColor: Colors.black,
              hintStyle: GoogleFonts.roboto(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              prefixIcon: Icon(Icons.search_rounded, color: Colors.black.withOpacity(0.6)),
              suffixIcon: SizedBox(
                width: 50,
                height: 50.0,
                child: Row(
                  children: [
                    Container(
                      height: 50.0,
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.tune_rounded,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
