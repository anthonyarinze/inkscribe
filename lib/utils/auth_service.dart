import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        'email': email,
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

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUserUid).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final username = data['username'];
        final email = data['email'];
        return {'username': username, 'email': email};
      } else {
        // User document does not exist
        return {'username': '', 'email': ''};
      }
    } on FirebaseException catch (error) {
      // Handle errors here
      ReusableFunctions.logError(error.message);
      return {};
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }

  Stream<Object> bookmarkStream() {
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
      final collectionReference = FirebaseFirestore.instance.collection('users').doc(currentUserUid).collection('bookmarks');

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
    String commentTitle,
    String comment,
    Color color,
  ) async {
    try {
      final userBookDoc = _firestore.collection('users').doc(currentUserUid).collection('bookmarks').doc(title);

      // Check if the book already exists in the user's collection
      final docSnapshot = await userBookDoc.get();

      if (docSnapshot.exists) {
        // The book exists in the user's collection, so add the comment;
        await userBookDoc.collection('comments').add({
          'commentTitle': commentTitle,
          'comment': comment,
          'timestamp': Timestamp.fromDate(DateTime.now()),
          'color': color.value,
        });
      } else {
        ReusableFunctions.logInfo("Selected title not found in user's collection");
      }
    } on FirebaseException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }

  Future<List<Comment>> getCommentsForBook(String title) async {
    try {
      final collectionReference = _firestore.collection('users').doc(currentUserUid).collection('bookmarks').doc(title).collection('comments');
      final snapshot = await collectionReference.get();

      final List<Comment> comments = [];
      for (var comment in snapshot.docs) {
        final data = comment.data();
        final title = data['commentTitle'] ?? '';
        final userComments = data['comment'] ?? '';
        final timestamp = data['timestamp'] ?? '';
        final id = comment.id;
        final color = data['color'] ?? '';

        comments.add(Comment(
          title,
          userComments,
          timestamp,
          id,
          color,
        ));
      }
      return comments;
    } on FirebaseException catch (error) {
      ReusableFunctions.logError(error.message);
      return []; // Return an empty list in case of an error
    }
  }

  Future<void> deleteComment(String title, String commentId) async {
    try {
      // Reference to the document containing the comment
      final commentRef = FirebaseFirestore.instance.collection('users').doc(currentUserUid).collection('bookmarks').doc(title).collection('comments').doc(commentId);

      // Delete the comment document
      await commentRef.delete();
    } on FirebaseException catch (error) {
      // Handle any errors, e.g., network issues
      ReusableFunctions.logError(error.message);
    }
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser!.delete();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }

  Future<void> confirmPasswordResetCode(String code, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseException catch (error) {
      ReusableFunctions.logError(error.message);
    }
  }
}
