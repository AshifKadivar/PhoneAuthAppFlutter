import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:otp_verification_ui/profile.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _Registration createState() => _Registration();
}

class _Registration extends State<Registration> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  String? _validationError;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dateofbrthController = TextEditingController();

  Future _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _validationError = null;
      setState(() async {
        _selectedImage = imageFile;
      });

      // Use imageUrl as needed, such as storing it in Firestore or displaying the image
    } else {
      _validationError = "No image selected.";
    }
  }

  void _validateAndSubmit() {
    setState(() {
      if (_selectedImage == null) {
        _validationError = "Please select an image.";
      } else {
        _validationError = null;
        // Proceed with further actions, e.g., form submission
        print("Image selected: ${_selectedImage!.path}");
      }
    });
  }

  Future<void> _uploadUserData() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.toString();
      String dateOfBirth = _dateofbrthController.text.toString();
      // String password = _passwordController.text.toString();
      String email = _emailController.text.toString();

      String? imageUrl;
      if (_selectedImage != null) {
        // Upload the image to Firebase Storage
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('user_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        UploadTask uploadTask = storageReference.putFile(_selectedImage!);
        TaskSnapshot storageTaskSnapshot =
            await uploadTask.whenComplete(() => null);
        imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
      }

      setState(() {
        DatabaseReference userRef = FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(FirebaseAuth.instance.currentUser!.uid);
        userRef.set({
          'dateOfBirth': dateOfBirth,
          'email': email,
          'username': username,
          'profilePhoto': imageUrl,
        });
      });

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );

      print('User data uploaded successfully');

      // return;
    } else {
      Get.snackbar("error", "Enter The Value");
    }
  }

  Future<void> _pickBirthdate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dateofbrthController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 15, 209),
        title: Text(
          'Registration Page',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    width: 80.0,
                    height: 80.0,
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child:
                                Image.file(_selectedImage!, fit: BoxFit.cover),
                          )
                        : Icon(Icons.add_photo_alternate, size: 50.0),
                  ),
                ),
              ),
              if (_validationError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    _validationError!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                child: TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelText: "UserName",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(191, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(223, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(10)),
                    prefix: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 83, 15, 209),
                        size: 14,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your User Name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  controller: _emailController,
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelText: "Email",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(191, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(223, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(10)),
                    prefix: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 83, 15, 209),
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                child: TextFormField(
                  controller: _dateofbrthController,
                  // decoration: InputDecoration(labelText: 'Birthdate'),
                  readOnly: true,
                  onTap: () => _pickBirthdate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a birthdate';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Date Of Birth",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(191, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(223, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(10)),
                    prefix: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.date_range,
                        color: Color.fromARGB(255, 83, 15, 209),
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _validateAndSubmit();
                  _uploadUserData();
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
