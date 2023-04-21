// ignore_for_file: avoid_print, unnecessary_null_comparison
import 'package:Nilinde/exceptions/exceptions.dart';
import 'package:Nilinde/models/profile_model.dart';
import 'package:Nilinde/pages/dashboard.dart';
import 'package:Nilinde/pages/login_page.dart';
import 'package:Nilinde/snackbar/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  //variables
  final _auth = FirebaseAuth.instance;
  final _firestoreInstance = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;
  User? user;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const LoginPage())
        : const DashboardScreen();
  }

  //login
  Future<void> loginUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((_) {
        Get.to(() => const DashboardScreen());
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  //logout
  Future<void> logout(BuildContext context) async =>
      await _auth.signOut().then((value) {
        CreateSnackBar.buildSuccessSnackbar(
            context: context,
            message: "Logged out successfully.",
            onPress: () {
              Get.to(() => const LoginPage());
            });
      });

  Future<void> updateUser(BuildContext context, ProfileModel user) async {
    try {
      await _auth.currentUser!.updateDisplayName(user.fullName);
      await _auth.currentUser!.updateEmail(user.email);
      await _firestoreInstance
          .collection('/users')
          .doc(_auth.currentUser!.uid)
          .update({
        "FullName": user.fullName,
        "Bio": user.bio,
        "Email": user.email,
        "Phone": user.phone
      }).then((value) {
        CreateSnackBar.buildSuccessSnackbar(
            context: context,
            message: "Profile infomation updated successfully.",
            onPress: () {
              Get.back();
            });
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }
}
