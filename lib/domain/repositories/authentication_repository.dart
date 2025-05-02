
import '../either.dart';
import '../enums.dart';
import '../enums_account.dart';
import '../models/user.dart';

abstract class AuthenticationRepository{
  Future<bool> get isSigneIn;
  Future<User?> getUserData();
  Future<void> singOut();
  /*Future<Either <SignInFailure, User>> signIn(
      String username,
      String password,
      );*/
  Future<Either<AccountUserFailure,String>> createFirebaseAccountUser(
      String email,
      String password
      );
  Future<Either<SignInFailure,User>> signInFirebaseAuthentication(
      String email,
      String password
      );
  Future<void> storeToken(String uid, String token);
  Future<void> deleteToken(String uid,String token);

}