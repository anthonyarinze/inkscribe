import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inkscribe/components/book_card.dart';
import 'package:inkscribe/utils/functions.dart';

import '../models/comment.dart';

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

  Stream<Object> stream() {
    return _firestore.collection('users').doc(currentUserUid).collection('bookmarks').snapshots();
  }

  Stream<Object> commentsStream(String title) {
    return _firestore.collection('users').doc(currentUserUid).collection('bookmarks').doc(title).collection('comments').snapshots();
  }

  void addToCollection(String title, String imageUrl, String author, String id, String synopsis) async {
    try {
      final userBookDoc = _firestore.collection('users').doc(currentUserUid).collection('bookmarks').doc(title);

      // Check if the book already exists in the user's collection
      final docSnapshot = await userBookDoc.get();

      if (!docSnapshot.exists) {
        // The book doesn't exist in the user's collection, so add it;
        await userBookDoc.set({
          'title': title,
          'imageUrl': imageUrl,
          'author': author,
          'id': id,
          'synopsis': synopsis,
        });
      } else {
        ReusableFunctions.logInfo("Selected title already in user's collection");
      }
    } on FirebaseException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }

  void removeFromCollection(String? title, String? id) async {
    try {
      await _firestore.collection('users').doc(currentUserUid).collection('bookmarks').doc(title ?? id).delete();
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
        final id = data['id'] ?? '';
        final synopsis = data['synopsis'] ?? '';

        books.add(BookCard(
          title: title,
          imageUrl: imageUrl,
          author: author,
          id: id,
          isHomePage: false,
          synopsis: synopsis,
        ));
      }

      return books;
    }
    return []; // Return empty list if user is not logged in
  }

  Future<void> addCommentToBook(
    String title,
    String comment,
  ) async {
    try {
      final userBookDoc = _firestore.collection('users').doc(currentUserUid).collection('bookmarks').doc(title);

      // Check if the book already exists in the user's collection
      final docSnapshot = await userBookDoc.get();

      if (docSnapshot.exists) {
        // The book exists in the user's collection, so add the comment;
        await userBookDoc.collection('comments').add({
          'comment': comment,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        ReusableFunctions.logInfo("Selected title not found in user's collection");
      }
    } on FirebaseException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }

  Future<List<String>> getCommentsForBook(String title) async {
    try {
      final userBookDoc = _firestore.collection('users').doc(currentUserUid).collection('bookmarks').doc(title).collection('comments');

      final querySnapshot = await userBookDoc.get();

      final comments = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return data['comment'] as String;
      }).toList();

      return comments;
    } on FirebaseException catch (error) {
      ReusableFunctions.logError(error.message);
      return []; // Return an empty list in case of an error
    }
  }
}
