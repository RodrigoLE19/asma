import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/models/user.dart' as AppUser;

class AuthenticationFirebase{

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future signInEmailAndPassword(String email,String password)async{
    try{
      UserCredential userCredential= await _auth.signInWithEmailAndPassword(email: email, password: password);
      final a=userCredential.user;
      if (a != null) {
        final doc = await _firestore.collection('user').doc(a.uid).get();
        if (doc.exists) {
          return AppUser.User.fromFirestore(doc);
        }
      }
      // if(a?.uid!=null){
      //   return a?.uid;
      // }
    }on FirebaseAuthException catch(e){
      if(e.code=="user-not-found"){
        return 1;
      }else if(e.code=="wrong-password"){
        return 2;
      }
    }
  }

  Future createAcountUser(String correo,String pass) async{
    try{
      UserCredential userCredential=await _auth.
      createUserWithEmailAndPassword(email: correo, password: pass);
      print(userCredential.user);
      return(userCredential.user?.uid);

    }on FirebaseAuthException catch(e){
      if(e.code=="weak-password"){
        print("The password provided is too weak");
        return 1;
      }else if(e.code=="email-already-in-use"){
        print("The account already exists for that email");
        return 2;
      }
    }catch(e){
      print(e);
    }
  }
}
