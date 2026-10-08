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

  /// Turns a guest (anonymous) account into a Google one, keeping the same
  /// user id so everything already synced stays put. If that Google account
  /// already exists, signs into it instead and [switched] is true.
  /// Returns null if the user cancelled.
  Future<({UserCredential credential, bool switched})?> linkWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final user = _auth.currentUser;
    if (user == null || !user.isAnonymous) {
      return (
        credential: await _auth.signInWithCredential(credential),
        switched: true,
      );
    }
    try {
      return (
        credential: await user.linkWithCredential(credential),
        switched: false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code != 'credential-already-in-use' &&
          e.code != 'email-already-in-use') {
        rethrow;
      }
      return (
        credential: await _auth.signInWithCredential(e.credential ?? credential),
        switched: true,
      );
    }
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
  /// does the data part; the phone's copy is AccountDataService's job.
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
