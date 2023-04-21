import 'package:Nilinde/common/theme_helper.dart';
import 'package:Nilinde/pages/widgets/header_widget.dart';
import 'package:Nilinde/snackbar/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isLoading=false;

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  double headerHeight = 250;
  final changePasswordFormKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<bool> changePassword(
      {required String currentPassword, required String newPassword}) async {
    bool success = false;
    var user = FirebaseAuth.instance.currentUser!;
    final credential = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(credential).then((value) async {
      await user.updatePassword(newPassword).then((value) {
        success = true;
      }).catchError((error) {
        success = false;
      });
    }).catchError((error) {
      success = false;
    });
    return success;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Change Password",
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
                  Icons.password_outlined,), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(
                    20, 10, 20, 10), // This will be the login form
                child: Column(
                  children: [
                    const Text(
                      'Hi,',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold,color:Colors.orange),
                    ),
                    const Text(
                      'Change your password',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                      key: changePasswordFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: oldPasswordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your old password";
                                }
                                return null;
                              },
                              decoration: ThemeHelper().textInputDecoration(
                                  'Old Password', 'Enter your old password'),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                         Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: newPasswordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your new password";
                                }
                                return null;
                              },
                              decoration: ThemeHelper().textInputDecoration(
                                  'New Password', 'Enter your new password'),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Confirm your new password";
                                }else if(value !=newPasswordController.text){
                                   return "Password mismatch";
                                }
                                return null;
                              },
                              decoration: ThemeHelper().textInputDecoration(
                                  'Confirm Password', 'Confirm your password'),
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
                                        'Submit'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (changePasswordFormKey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await changePassword(
                                currentPassword:
                                    oldPasswordController.text.trim(),
                                newPassword: newPasswordController.text.trim(),
                              ).then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (value) {
                                  CreateSnackBar.buildSuccessSnackbar(
                                      context: context,
                                      message: "Password changed successfully.",
                                      onPress: () {
                                        Get.back();
                                      });
                                } else {
                                  CreateSnackBar.buildCustomErrorSnackbar(
                                      context,
                                      "Error",
                                      "There was a problem changing your password.Try again later.");
                                }
                              }).onError((error, stackTrace) {
                                setState(() {
                                  isLoading = false;
                                });
                                CreateSnackBar.buildCustomErrorSnackbar(
                                    context,
                                    "Error",
                                    "There was a prblem changing your password.Try again later.");
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