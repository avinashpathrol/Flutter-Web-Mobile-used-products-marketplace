import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
   final String author;
   final String description;

  Book({required this.id, required this.author, required this.description});
   
factory Book.fromDocument(QueryDocumentSnapshot data) {
  return Book(
   id:data.data().toString().contains('id') ? data.get('id') : '',
   author:data.data().toString().contains('author') ? data.get('author') : '', 
   description: data.data().toString().contains('description') ? data.get('description') : '',

  );
} 
} 