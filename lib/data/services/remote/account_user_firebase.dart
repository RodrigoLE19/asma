import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/models/user.dart' as AppUser;

class AccountUserFirebase{

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createAccount(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user?.uid ?? '';
  }
  Future createAccountUserFirebaseAuthentication
      (String email,String password,String names,String lastname,String gender,String birthday) async {
    try {
      // Crear usuario en Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? uid = userCredential.user?.uid;

      if (uid != null) {
        List<String> namesPart = names.split(' ');
        String firstName = namesPart.isNotEmpty ? namesPart.first : '';

        // Separar apellidos
        List<String> lastNamePart = lastname.split(' ');
        String firsLastName = lastNamePart.isNotEmpty ? lastNamePart.first : '';
        // Crear usuario en Firestore
        await _firestore.collection('user').doc(uid).set({
          'uid': uid,
          'email': email,
          'names':names,
          'lastname':lastname,
          'displayName': firstName+' '+firsLastName ,
          'gender': gender,
          'birthday': birthday,
        });
        final doc = await _firestore.collection('user').doc(uid).get();
        if (doc.exists) {
          return AppUser.User.fromFirestore(doc);
        } // Indica que todo fue exitoso
      } else {
        return 3; // Error desconocido
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        print("The password provided is too weak");
        return 1;
      } else if (e.code == "email-already-in-use") {
        print("The account already exists for that email");
        return 2;
      } else {
        print("Unknown FirebaseAuthException: ${e.message}");
        return 3; // Error desconocido
      }
    } catch (e) {
      print("Unknown error: $e");
      return 3; // Error desconocido
    }

  }

}