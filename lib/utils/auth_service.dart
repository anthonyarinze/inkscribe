import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inkscribe/components/book_card.dart';
import 'package:inkscribe/utils/functions.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final currentUserUid = _auth.currentUser!.uid;

  Future<void> signUpWithEmailAndPassword(String username, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
      });

      //Cache username locally
      await ReusableFunctions().cacheUsername(username);
    } on FirebaseAuthException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }

  void addToCollection(String title, String imageUrl, String author) async {
    try {
      await _firestore.collection('users').doc(currentUserUid).collection('bookmarks').doc(title).set({
        'title': title,
        'imageUrl': imageUrl,
        'author': author,
      });
    } on FirebaseException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }

  void removeFromCollection(String title) async {
    try {
      await _firestore.collection('users').doc(currentUserUid).collection('bookmarks').doc(title).delete();
    } on FirebaseException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }

  Future<List<BookCard>> getBooksFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final collectionReference = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('bookmarks');

      final snapshot = await collectionReference.get();

      // Iterate through the documents and extract the data
      final List<BookCard> books = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final title = data['title'] ?? '';
        final imageUrl = data['imageUrl'] ?? '';
        final author = data['author'] ?? '';
        books.add(BookCard(title: title, imageUrl: imageUrl, author: author));
      }

      return books;
    }
    return []; // Return empty list if user is not logged in
  }
}
