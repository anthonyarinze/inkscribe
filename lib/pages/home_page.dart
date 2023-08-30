import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/utils/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            TextButton(
              onPressed: () {},
              style: const ButtonStyle(),
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
          ],
        ),
      ),
    );
  }
}
