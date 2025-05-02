import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/either.dart';
import '../../domain/enums_account.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/account_repository.dart';
import '../services/remote/account_user_firebase.dart';

const _key='sessionId';

class AccountRepositoryImpl implements AccountRepository {
  final AccountUserFirebase _accountUserFirebase;
  final FlutterSecureStorage _secureStorage;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AccountRepositoryImpl(this._accountUserFirebase,this._secureStorage);

  @override
  Future<String> createAccountUserFirebase(String email, String password) async {
    final result = await _accountUserFirebase.createAccount(email, password);
    return result;
  }

  @override
  Future<Either<AccountUserFailure, User>> createUserAccountFirebase(String email, String password, String names, String lastname, String gender, String birthday) async {
    final user=await _accountUserFirebase.createAccountUserFirebaseAuthentication(email, password, names, lastname, gender, birthday);
    if(user==1){
      return Either.left(AccountUserFailure.passwordWeak);
    }else if(user==2){
      return Either.left(AccountUserFailure.emailAlreadyRegistered);
    }else if(user==3){
      return Either.left(AccountUserFailure.UnknownFirebaseAuthException);
    }else{
      await _secureStorage.write(key: _key, value: user.uid);
      return Either.right(user);
    }
  }

  @override
  Future<User> registerUserFirebase(String uid, String email, String names, String displayName, String lastName, String gender, String birthday) async {
    final user = User(
        uid: uid,
        email: email,
        names: names,
        displayName: displayName,
        lastName: lastName,
        gender: gender,
        birthday: birthday
    );

    await _firestore.collection('user').doc(uid).set(user.toMap());

    return user;
  }

  @override
  Future<User?> userRegisterFirebase(String uid, String email, String displayName, String gender, String birthday) {
    // TODO: implement userRegisterFirebase
    throw UnimplementedError();
  }


}