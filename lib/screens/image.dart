import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'auth.dart';
import 'dart:io' as io;

final ImagePicker _picker = ImagePicker();
PickedFile? _imagePickerFile;
var uuid = Uuid();

class ChoosenImage extends StatefulWidget {
  ChoosenImage({Key? key}) : super(key: key);

  @override
  _ChoosenImageState createState() => _ChoosenImageState();
}

class _ChoosenImageState extends State<ChoosenImage> {
  User? user;
  bool currentUser = false;
  String? link;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Choosen Image Upload Firebase Storage'),
          actions: [
            IconButton(
                icon: Icon(Icons.single_bed),
                onPressed: () {
                  setState(() {
                    currentUser = true;
                  });
                })
          ],
        ),
        body: FutureBuilder(
          future: uploadData(_imagePickerFile!),
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  choosenImageWidget,
                  snapshot.data == null
                      ? Text('')
                      : Text(snapshot.data.toString())
                ]);
          },
        ),
      ),
    );
  }

  Widget get choosenImageWidget {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: choosenImageWithPicker, child: Text('Choose Image'))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imagePickerFile == null
                ? Text('Image will be uiploadad.')
                : SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(_imagePickerFile!.path),
                  )
          ],
        ),
      ],
    );
  }

  Future<void> choosenImageWithPicker() async {
    try {
      final file = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _imagePickerFile = file;
      });
    } catch (err) {
      print(err);
    }
  }

  Future<String?> uploadData(PickedFile file) async {
    try {
      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No file was selected')));
        return null;
      }
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('files')
          .child('${uuid.v4()}.jpg');
      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': file.path});
      if (kIsWeb) {
        ref.putData(await file.readAsBytes(), metadata);
      } else {
        ref.putFile(io.File(file.path), metadata);
      }
      return ref.getDownloadURL();
    } catch (err) {
      print(err);
      return null;
    }
  }
}
