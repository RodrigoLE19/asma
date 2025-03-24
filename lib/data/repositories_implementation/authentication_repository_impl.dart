
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../../../domain/repositories/authentication_repository.dart';
import '../../../presentation/models/user.dart';
import '../../domain/enums_account.dart';
import '../services/remote/authentication_firebase.dart';

const _key = 'sesionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository{
  final FlutterSecureStorage _secureStorage;
  final AuthenticationFirebase _authenticationFirebase;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthenticationRepositoryImpl(
      this._secureStorage,
      this._authenticationFirebase
      );


  @override
  Future<User?> getUserData() async {
    final uid = await _secureStorage.read(key: _key);
    if (uid == null) return null;

    final doc = await _firestore.collection('user').doc(uid).get();
    if (doc.exists) {
      return User.fromFirestore(doc);
    }
    return null;
  }
  /*@override
  Future<User?> getUserData() {
    return Future.value(
      User(),
    );
  }*/

  @override
  Future<bool> get isSigneIn async {
    final sesionId = await _secureStorage.read(key: _key);
    return sesionId != null;
  }

  /*@override
  Future<Either<SignInFailure, User>> signIn(
      String username,
      String password,
      ) async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
    if(username!='test'){
      return Either.left(SignInFailure.notFound);
    }
    if(password!='123456'){
      return Either.left(SignInFailure.unauthorized);
    }
    
    await _secureStorage.write(key: _key, value: '123');

    return Either.right(
      User(),
    );
  }*/

  @override
  Future<Either<SignInFailure, User>> signInFirebaseAuthentication(
      String email,
      String password
      ) async {
    final user = await _authenticationFirebase.signInEmailAndPassword(email, password);
    if (user == null) {
      return Either.left(SignInFailure.userNotFound);
    }
    await _secureStorage.write(key: _key, value: user.uid);
    return Either.right(user);
  }

  @override
  Future<void> singOut()  {
     return _secureStorage.delete(key: _key);
  }

  /*@override
  Future<Either<SignInFailure, User>> signInFirebaseAuthentication(String email, String password) {
    // TODO: implement signInFirebaseAuthentication
    throw UnimplementedError();
  }*/

  @override
  Future<Either<AccountUserFailure, String>> createFirebaseAccountUser(String email, String password)async {
    final user = await _authenticationFirebase.createAcountUser(email, password);
    if (user == 1) {
      return Either.left(AccountUserFailure.passwordWeak);
    }else if(user==2){
      return Either.left(AccountUserFailure.emailAlreadyRegistered);
    }else{
      // await _secureStorage.write(key: _key, value: user.uid);
      return Either.right(user);
    }
  }

  @override
  Future<void> deleteToken(String uid,String token)async {
    await FirebaseFirestore.instance.collection('user').doc(uid).update({
      'token': FieldValue.arrayRemove([token]), // Eliminar solo el token del dispositivo actual
    });
  }

  @override
  Future<void> storeToken(String uid, String token) async{
    await FirebaseFirestore.instance.collection('user').doc(uid).update({
      'token': FieldValue.arrayUnion([token]), // Añadir el token a la lista
    });
  }

}