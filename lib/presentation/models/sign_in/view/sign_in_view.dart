import 'package:asma/domain/repositories/authentication_repository.dart';
import 'package:asma/utils/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../../../../domain/enums.dart';
import 'package:asma/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../preferences/pref_usuarios.dart';
import '../../../global/controller/session_controller.dart';
import '../../../routes/routes.dart';
import '../controller/sign_in_controller.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  String? emailValidator(String? value) {
    // Expresión regular para validar el formato de un correo electrónico
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (value == null || value.isEmpty) {
      return "El campo de correo electronico esta vacio";
      //return AppLocalizations.of(context)!.emailEmpty;
    } else if (!emailRegex.hasMatch(value)) {
      return "Ingrese un correo electronico valido";
      //return AppLocalizations.of(context)!.email_valid;
    }
    return null;
  }
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "El campo de contraseña esta vacio";
      //return AppLocalizations.of(context)!.passwordEmpty;
    }
    return null;
  }

  /*String _username='', _password='';
  bool _fetching = false;*/

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      create: (_)=>SignInController(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                      children: [
                        SizedBox(height: 70,),
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
                                "Inicia sesión si ya tienes una cuenta, o Regístrate para crear una cuenta",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 70,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(50),
                            child: Column(
                              children: [
                                FormBuilder(
                                  key: _formKey,
                                  child: Builder(
                                      builder: (context) {
                                        final controller= Provider.of<SignInController>(context);
                                        return AbsorbPointer(
                                          absorbing: controller.fetching,
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 1.5)),
                                                ),
                                                child: FormBuilderTextField(
                                                  validator: emailValidator,
                                                  onChanged: (value) {
                                                    controller.onEmailChanged(value!);
                                                    final formState = _formKey.currentState;
                                                    formState?.fields['email']?.validate();
                                                  },
                                                  name: 'email',
                                                  autofocus: true,
                                                  style: TextStyle(color: Color(0xFF145E72)),
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(Icons.email, color: Color(0xFF2D9CB1)),
                                                    hintText: "Email",
                                                    hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
                                                    border: InputBorder.none, // Elimina bordes no deseados
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 1.5)),
                                                ),
                                                child: FormBuilderTextField(
                                                  validator: passwordValidator,
                                                  onChanged: (value) {
                                                    controller.onPasswordChanged(value!);
                                                    final formState = _formKey.currentState;
                                                    formState?.fields['password']?.validate();
                                                    if (value!.length >= 8) {
                                                      FocusScope.of(context).unfocus();
                                                    }
                                                  },
                                                  name: 'password',
                                                  style: TextStyle(color: Color(0xFF145E72)),
                                                  obscureText: controller.obscureText,
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(Icons.lock, color: Color(0xFF2D9CB1)),
                                                    hintText: "Password",
                                                    hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
                                                    border: InputBorder.none, // Elimina bordes no deseados
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        controller.obscureText ? Icons.visibility : Icons.visibility_off,
                                                        color: Color(0xFF2D9CB1),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          controller.onObscureTextChanged(!controller.obscureText);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 20,),
                                              if (controller.fetching)
                                                CircularProgressIndicator()
                                              else
                                                MaterialButton(
                                                  onPressed: () async {
                                                    _formKey.currentState?.save();
                                                    if (_formKey.currentState!.validate() ==
                                                        true) {
                                                      _submit(context);
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                              content: Text("Campos vacios")));
                                                      
                                                    }
                                                  },
                                                  child: Text(
                                                    "Inciar sesion",
                                            
                                                    style: TextStyle(
                                                        color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                  color: Color(0xFF073D47),
                                                  minWidth: 250,
                                                  height: 50,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(50),
                                                  ),
                                                ),
                                              SizedBox(height: 0,),
                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                ),
                                SizedBox(height: 20,),
                                //Text("¿Olvidaste tu Contraseña?", style: TextStyle(color: Color(0xFF2D9CB1))),
                                SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context, Routes.registerUser);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2E7B8A),
                                    minimumSize: Size(250, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Text(
                                      "Crear una cuenta",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                ),
                                SizedBox(height: 30),
                                //_buildGoogleButton(),
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

  /*Widget _buildGoogleButton() {
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
  }*/

  Future<void> _submit(BuildContext context)async{
    final SignInController controller= context.read();
    controller.onFetchingChanged(true);
    final result=await context.read<AuthenticationRepository>().signInFirebaseAuthentication(
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
          SignInFailure.userNotFound:"Usuario no encontrado",
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
        Navigator.pushReplacementNamed(
            context,
            Routes.menu_home,
            arguments: {'typeLogin':'FA'}
        );
      },
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