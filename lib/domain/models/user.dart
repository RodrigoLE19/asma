import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String uid;
  final String email;
  final String names;
  final String displayName;
  final String lastName;
  final String gender;
  final String birthday;
  final String doctorName; //NUEVO CAMPO
  final String doctorPhone; //NUEVO CAMPO

  User({
    required this.uid,
    required this.email,
    required this.names,
    required this.displayName,
    required this.lastName,
    required this.gender,
    required this.birthday,
    required this.doctorName,
    required this.doctorPhone,
  });

  // Método para crear una instancia de User desde un documento de Firestore
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      email: data['email'] ?? '',
      names: data['names'] ?? '', //AGREGUE LA 's' a "name"
      displayName: data['displayName'] ?? '',
      lastName: data['lastname'] ?? '',
      gender: data['gender'] ?? '',
      birthday: data['birthday'] ?? '',
      doctorName: data['doctor_name'] ?? '',
      doctorPhone: data['doctor_phone'] ?? '',
    );
  }

  // Método para crear un mapa de los datos del usuario
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'names': names,
      'displayName': displayName,
      'lastname': lastName,
      'gender': gender,
      'birthday': birthday,
      'doctor_name': doctorName,
      'doctor_phone': doctorPhone,
    };
  }






















  @override
  // TODO: implement props
  List<Object?> get props => [
    uid,
    email,
    names,
    displayName,
    lastName,
    gender,
    birthday
  ];
}

