import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'otp.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<PhoneAuth> {
  TextEditingController phonecontroller = TextEditingController();
  bool _isValid = false;
  bool _isEnter = false;

  void _checkInput() {
    setState(() {
      // Example condition: Crheck if the input is a valid phone numbe (simple length check here)
      _isValid = phonecontroller.text.length == 10;
      _isEnter = phonecontroller.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    phonecontroller.addListener(_checkInput);
  }

  Future<void> _verifyPhoneNumber(
      BuildContext context, String phonecontroller) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithPhoneNumber("+91" + phonecontroller);

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: "+91" + phonecontroller,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!

          // Sign the user in (or link) with the auto-generated credential
          //await auth.signInWithCredential(credential);
        },

        codeSent: (String verificationId, int? resendToken) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => Otp(
                      phonecontroller: phonecontroller,
                      verificationid: verificationId,
                    )),
          );

          Fluttertoast.showToast(
            msg: "Verification completed : $resendToken",
            toastLength: Toast
                .LENGTH_SHORT, // Duration for which the toast will be displayed (short or long)
            gravity: ToastGravity
                .BOTTOM, // Position of the toast message on the screen
            timeInSecForIosWeb: 5, // Time in seconds for iOS and web
            backgroundColor:
                Colors.black87, // Background color of the toast message
            textColor: Colors.white, // Text color of the toast message
            fontSize: 16.0, // Font size of the toast message
          );
        }, //codeAutoRetrievalTimeout: (String verificationId) {  };
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
          //print('Verification timed out: $verificationId');
          Fluttertoast.showToast(
            msg: "Verification timed out: $verificationId",
            toastLength: Toast
                .LENGTH_SHORT, // Duration for which the toast will be displayed (short or long)
            gravity: ToastGravity
                .BOTTOM, // Position of the toast message on the screen
            timeInSecForIosWeb: 5, // Time in seconds for iOS and web
            backgroundColor:
                Colors.black87, // Background color of the toast message
            textColor: Colors.white, // Text color of the toast message
            fontSize: 16.0, // Font size of the toast message
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
          // print('Verification failed: ${e.message}');
          Fluttertoast.showToast(
            msg: "Verification failed: ${e.message}",
            toastLength: Toast
                .LENGTH_SHORT, // Duration for which the toast will be displayed (short or long)
            gravity: ToastGravity
                .BOTTOM, // Position of the toast message on the screen
            timeInSecForIosWeb: 5, // Time in seconds for iOS and web
            backgroundColor:
                Colors.black87, // Background color of the toast message
            textColor: Colors.white, // Text color of the toast message
            fontSize: 16.0, // Font size of the toast message
          );
        },
      );
    } catch (e) {
      // Handle other errors
      print('Error verifying phone number: $e');
      Fluttertoast.showToast(
        msg: "Error verifying phone number: $e",
        toastLength: Toast
            .LENGTH_SHORT, // Duration for which the toast will be displayed (short or long)
        gravity:
            ToastGravity.BOTTOM, // Position of the toast message on the screen
        timeInSecForIosWeb: 5, // Time in seconds for iOS and web
        backgroundColor:
            Colors.black87, // Background color of the toast message
        textColor: Colors.white, // Text color of the toast message
        fontSize: 16.0, // Font size of the toast message
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 15, 209),
        title: Text(
          'Phone Auth',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 18,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/illustration-2.png',
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Phone Authentication',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Add your phone number. we'll send you a verification code so we know you're real",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 28,
                ),
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        maxLength: 10,
                        controller: phonecontroller,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your User Name';
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: _isValid
                              ? Icon(Icons.check)
                              : (_isEnter
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        phonecontroller.clear();
                                        setState(() {
                                          _isEnter = false;
                                          _isValid = false;
                                        });
                                      },
                                    )
                                  : null),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 6),
                            child: Text(
                              "+91 ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _verifyPhoneNumber(context, phonecontroller.text);
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 83, 15, 209)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Send',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
