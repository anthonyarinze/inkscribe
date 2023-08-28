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
            controller: textEditingController,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search for a book...",
              hintStyle: GoogleFonts.roboto(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              prefixIcon: const Icon(Icons.search_rounded),
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
                      icon: const Icon(Icons.tune_rounded),
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
