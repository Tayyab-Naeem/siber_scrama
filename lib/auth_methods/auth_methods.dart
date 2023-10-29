import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:siber_scrama/models/user_model.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  /// signup Users
  Future<String> signUpUser({
    required String userName,
    required String email,
    required String password,
    required String phone,
  }) async {
    String res = "Some Error occurs";
    try {
      if (email.isNotEmpty ||
          phone.isNotEmpty ||
          userName.isNotEmpty ||
          password.isNotEmpty) {
        UserCredential credential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print("User Id is:::: ${credential.user!.uid}");

        /// add users in database
        UserModel userModel = UserModel(
            userName: userName,
            uid: credential.user!.uid,
            email: email,
            password: password,
            phone: phone);
        await firebaseFirestore
            .collection("users")
            .doc(credential.user!.uid)
            .set(userModel.toJason());
        return res = "Sucess";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  /// loging in user
  Future<String> loginInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        print("Sucess");
        res = "Success";
      } else {
        res = "Please Enter All the Fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
