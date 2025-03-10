import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static AuthService authService = AuthService._();
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<String> registerUser({
    required String email,
    required String password,
  }) async {
    String msg = "";
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      msg = "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        msg = "The password provided is too weak";
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        msg = "The account already exists for that email.";
        print('The account already exists for that email.');
      } else {
        msg = e.code;
      }
    }

    return msg;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String msg = "";
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      msg = "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        msg = "No user found for that email.";
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        msg = "Wrong password provided for that user.";
        print('Wrong password provided for that user.');
      } else {
        msg = e.code;
      }
    }
    return msg;
  }
  //
  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;
}
