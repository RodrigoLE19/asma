
import 'package:asma/domain/repositories/authentication_repository.dart';
import 'package:asma/presentation/models/home/views/evaluations_view.dart';
import 'package:asma/utils/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../../../../domain/enums.dart';
import '../../../../main.dart';
import '../../../../preferences/pref_usuarios.dart';
import '../../../global/controller/session_controller.dart';
import '../../../routes/routes.dart';
import 'package:asma/presentation/models/register_user/view/register_user_view.dart';


import '../controller/sign_in_controller.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  /*String _username='', _password='';
  bool _fetching = false;*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: FormBuilder(
          key: _formKey,
          child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 70),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Bienvenido",
                        style: TextStyle(color: Colors.white, fontSize: 36),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Inicia sesión si ya tienes una cuenta, o Regístrate para crear una",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        _buildTextField(Icons.person, "Correo"),
                        _buildTextField(Icons.person, "Contraseña"),
                        SizedBox(height: 30),
                        _buildButton("Iniciar Sesión", Color(0xFF073D47), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EvaluationsView()),
                          );
                        }),
                        SizedBox(height: 20),
                        Text("¿Olvidaste tu Contraseña?", style: TextStyle(color: Color(0xFF2D9CB1))),
                        SizedBox(height: 40),
                        _buildButton("Registro", Color(0xFF2E7B8A), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterUserView()),
                          );
                        }),
                        SizedBox(height: 30),
                        _buildGoogleButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, {bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 0.5)),
        ),
        child: TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hint,
            hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        minimumSize: Size(250, 50),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
  Widget _buildGoogleButton() {
    return SizedBox(
      //width: MediaQuery.of(context).size.width * 0.9,
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          print("Botón de Google presionado");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Colors.grey),
          ),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/google_logo.png',
              height: 24,
              width: 24,
            ),
            SizedBox(width: 10),
            Text(
              "Continuar con Google",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Future<void> _submit(BuildContext context)async{
    final SignInController controller = context.read();
    controller.onFetchingChanged(true);
    final result= await context.read<AuthenticationRepository>().signInFirebaseAuthentication(
      controller.email,
      controller.password,
    );
    if(!mounted){
      return;
    }
    result.when(
          (failure){
        controller.onFetchingChanged(false);
        final meesage={
          /*SignInFailure.userNotFound:AppLocalizations.of(context)!.userNotFound,*/
          SignInFailure.wrongPassword:'Contraseña incorrecta',
        } [failure];
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(meesage!))
        );
      },
          (user){
        SessionController sessionController=context.read();
        sessionController.setUser(user);
        final prefs = PreferenciasUsuario();
        prefs.tipoLogin = 'FA';
        /*Navigator.pushReplacementNamed(
            context,
            Routes.menu_home,
            arguments: {'typeLogin':'FA'}
        );*/
      },
    );
  }*/

  /*Future<void> _submit(BuildContext context) async{
    setState(() {
      _fetching =true;
    });
    final result = await Injector.of(context).authenticationRepository.signIn(
      _username,
      _password,
    );

    if (!mounted){
      return;

    }

    result.when(
          (failure) {
        setState(() {
          _fetching = false;
        });
        final message = {
          SignInFailure.notFound:'Not Found',
          SignInFailure.unauthorized:'Invalid password',
          SignInFailure.unknown:'Error',
        }[failure];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
          ),
        );
      },
          (user) {
        Navigator.pushReplacementNamed(
          context,
          Routes.home,
        );
      },
    );

  }*/
}