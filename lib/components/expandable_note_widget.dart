import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/comment.dart';

class ExpandableNoteWidget extends StatelessWidget {
  const ExpandableNoteWidget({
    Key? key,
    required this.userComments,
    required this.timeFormattedDateTime,
    required this.dateFormattedDateTime,
    required this.color,
  }) : super(key: key);

  final Comment userComments;
  final String timeFormattedDateTime;
  final String dateFormattedDateTime;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ExpansionTileCard(
        initiallyExpanded: true,
        title: Text(
          userComments.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.roboto(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        expandedTextColor: Colors.white,
        baseColor: color,
        expandedColor: color,
        borderRadius: BorderRadius.circular(10.0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SelectableText(
                  userComments.text,
                  maxLines: 4,
                  style: GoogleFonts.roboto(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeFormattedDateTime,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      dateFormattedDateTime,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
