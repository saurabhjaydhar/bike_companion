import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns null if the user cancelled the Google sign-in sheet.
  Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  /// Sign in anonymously so the user can use the app without a Google account.
  Future<UserCredential> signInAnonymously() =>
      _auth.signInAnonymously();

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Deletes the account and everything stored for it in the cloud
  /// (Firestore records, Storage photos), as app stores require. [eraseCloud]
  /// does the data part; local data on this device stays.
  /// Firebase requires a recent sign-in — may throw [FirebaseAuthException]
  /// with code 'requires-recent-login'.
  Future<void> deleteAccount({
    required Future<void> Function(String uid) eraseCloud,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await eraseCloud(user.uid);
    if (!user.isAnonymous) await _googleSignIn.signOut();
    await user.delete();
  }
}
