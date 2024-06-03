import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  String username = "";
  String email = "";
  String dateOfBrith = "";
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    // Fetch data from the database when the screen initializes
    readDataFromDatabase();
  }

  void readDataFromDatabase() async {
    DatabaseReference databaseRef = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(FirebaseAuth.instance.currentUser!.uid);

    final snapshot = await databaseRef.child("username").get();
    if (snapshot.exists) {
      setState(() {
        username = snapshot.value.toString();
      });
    }

    final snapshot1 = await databaseRef.child("email").get();
    if (snapshot1.exists) {
      setState(() {
        email = snapshot1.value.toString();
      });
    }

    final snapshot2 = await databaseRef.child("dateOfBirth").get();
    if (snapshot2.exists) {
      setState(() {
        dateOfBrith = snapshot2.value.toString();
      });
    }

    final snapshot3 = await databaseRef.child("profilePhoto").get();
    if (snapshot3.exists) {
      setState(() {
        imageUrl = snapshot3.value.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 15, 209),
        title: Text(
          'Profile Page',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(50.0),
              ),
              width: 80.0,
              height: 80.0,
              // ignore: unnecessary_null_comparison
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    )
                  : Icon(Icons.add_photo_alternate, size: 50.0),
            ),
            SizedBox(height: 20.0),
            Text(
              "UserName : " + username,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              "Email : " + email,
              //getUserEmail(),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              "Date Of Birth : " + dateOfBrith,
              // getUserDateOfBirth() as String,
              style: TextStyle(fontSize: 16.0),
            ),
          ]),
        ),
      ),
    );
  }
}
