import '../either.dart';
import '../enums_account.dart';
import '../models/user.dart';

abstract class AccountRepository {
  Future<String> createAccountUserFirebase(String email, String password);
  Future<User> registerUserFirebase(String uid, String email,String names, String displayName,String lastName, String gender, String birthday, String doctorName, String doctorPhone);
  //METODOS MEJORADOS PARA CREAR CUENTA Y VERIFICAR SI HAY ALGUN PROBLEMA
  //PARA DESPUES CREAR LA CUENTA
  Future<Either<AccountUserFailure,User>> createUserAccountFirebase(String email,String password,String names,String lastname,String gender,String birthday, String doctorName, String doctorPhone);
  Future<User?> userRegisterFirebase(
      String uid,
      String email,
      String displayName,
      String gender,
      String birthday,
      String doctorName,
      String doctorPhone
      );
}