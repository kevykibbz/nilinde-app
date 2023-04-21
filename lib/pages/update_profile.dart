import 'package:Nilinde/common/theme_helper.dart';
import 'package:Nilinde/models/profile_model.dart';
import 'package:Nilinde/pages/firebase/firebaseauth.dart';
import 'package:Nilinde/pages/widgets/header_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


bool isLoading=false;

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  double headerHeight = 250;
  final updateProfileFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      var data = value.data() as Map;
      print("DATAAAAAA:$data");
      nameController.text = data['FullName'];
      emailController.text = data['Email'];
      bioController.text = data['Bio'].toString();
      phoneController.text = data['Phone'].toString();
    });
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Profile",
          style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation:3,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
      ),
       body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: headerHeight,
              child: HeaderWidget(headerHeight, true,
                  Icons.edit,), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(
                    20, 10, 20, 10), // This will be the login form
                child: Column(
                  children: [
                    const Text(
                      'Hey there,',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold,color:Colors.orange),
                    ),
                    const Text(
                      'Edit your profile',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                      key: updateProfileFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your name";
                                }
                                return null;
                              },
                              decoration: ThemeHelper().textInputDecoration(
                                  'Full Name', 'Enter your name'),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your email address";
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                    .hasMatch(value)) {
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                              decoration: ThemeHelper().textInputDecoration(
                                  'Email', 'Enter your email address'),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType:TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your phone number";
                                } 
                                return null;
                              },
                              decoration: ThemeHelper().textInputDecoration(
                                  'Phone', 'Enter your phone number'),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: bioController,
                              decoration: ThemeHelper().textInputDecoration(
                                  'Bio', 'Little description about you.'),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          isLoading
                              ? const CircularProgressIndicator( 
                                valueColor:AlwaysStoppedAnimation(Colors.orange),
                              )
                              : Container(
                                  width: double.infinity,
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 10, 40, 10),
                                      child: Text(
                                        'Update'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (updateProfileFormKey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        final user = ProfileModel(
                                        fullName:nameController.text.trim(),
                                        email:emailController.text.trim(),
                                        bio:bioController.text.trim(),
                                        phone: int.parse(phoneController.text.trim()),
                                      );
                                      await AuthRepository.instance
                                          .updateUser(context, user)
                                          .then((value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }).onError((e, stackTrace) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });
                                      }
                                    },
                                  ),
                                ),
                          const SizedBox(height: 20),
                          Center(
                            child: Row(
                              crossAxisAlignment:CrossAxisAlignment.center,
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                Text(
                                  "\u00a9 ${DateTime.now().year} All Rights Reserved.",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "Nilinde.",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight:FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}