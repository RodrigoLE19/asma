import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../preferences/pref_usuarios.dart';
import '../../../global/controller/session_controller.dart';
import '../../../routes/routes.dart';

class UserProfileView extends StatefulWidget {
  //final String typeLogin;
  const UserProfileView({Key? key}) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();

}
class _UserProfileViewState extends State<UserProfileView> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    final user = sessionController.state!;
    final DateTime fechaActual = DateTime.now();
    final DateFormat formato = DateFormat('dd/MM/yyyy');
    final String fechaActualFormateada = formato.format(fechaActual);
    final genero = user.gender?.isEmpty ?? true ? 'Actualizar' : user.gender;
    final fechaNacimiento = user.birthday?.isEmpty ?? true ? 'Actualizar' : user.birthday;
    final names = user.names;
    final lastname = user.lastName;
    final email = user.email;

    String nombresUsuario(String _typeLogin,String _names,String _lastName,String _displayName){
      String usuarioName='';
      if(_typeLogin=='FA'){
        if(_names!=null && _names!='' && _lastName!='' && _lastName!=null && _displayName!='' && _displayName!=null)
          usuarioName=_names.split(' ').first+' '+_lastName.split(' ').first;

      }else {
        usuarioName = _displayName;
      }
      return usuarioName;
    }
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('user').doc(user.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container(color: Color(0xFF2B6178),child: Center(child: CircularProgressIndicator(color: Colors.white,backgroundColor: Colors.grey,)));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No user data available'));
        } else {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final updatedGender = userData['gender'] ?? 'Actualizar';
          final updatedBirthday = userData['birthday'] ?? 'Actualizar';
          var prefs=PreferenciasUsuario();
          // final displayNameUpdate=nombresUsuario(widget.typeLogin,userData['names'] , userData['lastname'], userData['displayName']);
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2D9CB1),
                  Color(0xFF003E49),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/LogoApp.png',
                          height: 120,
                          width: 120,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Hola, ",
                                style: TextStyle(color: Colors.white, fontSize: 36),
                              ),
                              TextSpan(
                                text: '${userData['displayName']}',
                                style: TextStyle(color: Colors.white, fontSize: 36),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Text("Fecha actual: "+'$fechaActualFormateada',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          //color: Color(0xFF2D9CB1),

                          child: Center(
                            child: Text(
                              "Perfil de usuario",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          color: Color(0xFFD9D9D9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Alignment.bottomRight;
                                      //_showInfoDialog(context);
                                    },
                                    icon: Icon(Icons.info),
                                  ),
                                ],
                              ),*/
                              buildInfoField("Nombres y apellidos", userData['displayName']),
                              buildInfoField("Correo", user.email),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0.0, right: 10),
                                      child: buildInfoField("Género", updatedGender),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0.0, right: 10),
                                      child: buildInfoField("Fecha de nacimiento", updatedBirthday),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1), // Espaciado interno
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2D9CB1), // Color de fondo
                                      borderRadius: BorderRadius.circular(8), // Bordes redondeados
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Actualizar datos",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          IconButton(
                                            onPressed: () async {
                                              // setState(() {
                                              //   _isLoading = true;
                                              // });
                                              /*if (widget.typeLogin == 'GA') {
                                                  await showInfoUpdateUserGoogle(context, user.uid, userData['gender'], userData['birthday']);
                                                } else {
                                                await showInfoUpdateUser(context, user.uid, userData['names'], userData['lastname'], userData['email'], userData['gender'], userData['birthday']);
                                                }*/
                                              // setState(() {
                                              //   _isLoading = false;
                                              // });
                                            },
                                            icon: Icon(
                                                Icons.create,
                                                color: Colors.white,
                                            ),
                                          ),
                                        ],
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Cerrar sesión",
                              style: TextStyle(
                                color: Colors.red, // Color rojo al texto
                                fontWeight: FontWeight.bold, // Negrita opcional
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                deleteToken(context, user.uid, prefs.token);
                                prefs.token = '';
                                try {
                                  await signoutFirebaseAuthGoogle(context);
                                  print("Sesión de Google cerrada");
                                } catch (e) {
                                  print("ERROR: $e");
                                }
                                Navigator.pushReplacementNamed(context, Routes.signIn);
                              },
                              icon: Icon(Icons.logout, color: Colors.red),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
  Future<void> deleteToken(BuildContext context,String uid,String token)async {
    try{
      await context.read<AuthenticationRepository>().deleteToken(uid,token);
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"))
      );
    }
  }
  Future<void> signoutFirebaseAuthGoogle(BuildContext context)async {
    try{

      await context.read<AuthenticationRepository>().singOut();
      //await context.read<AuthenticationRepository>().signOutGoogle();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"))
      );
    }
  }



  Widget buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF637D8B),
          title: Text("Informacion1", style: TextStyle(color: Colors.white)),
          content: Text(
              "Login google",
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text("OK", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

String convertTimestampToDateString(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(dateTime);
}

