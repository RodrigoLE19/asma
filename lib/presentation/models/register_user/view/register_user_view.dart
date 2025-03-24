import 'package:asma/presentation/models/sign_in/view/sign_in_view.dart';
import 'package:asma/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(  // Permite desplazarse cuando aparece el teclado
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: FormBuilder(  // Agregando FormBuilder
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 70),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Bienvenido",
                        style: TextStyle(color: Colors.white, fontSize: 36),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Registrate, para poder iniciar sesión",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
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
                        _buildTextField(Icons.person, "Nombres"),
                        _buildTextField(Icons.person, "Apellidos"),
                        _buildTextField(Icons.email, "Correo"),
                        _buildDatePickerField(context),
                        _buildTextField(Icons.lock, "Contraseña", obscureText: true),
                        _buildTextField(Icons.lock, "Confirmar Contraseña", obscureText: true),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF073D47),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minimumSize: Size(250, 50),
                          ),
                          onPressed: () async {
                            _formKey.currentState?.save();
                            if(_formKey.currentState?.validate()==true){
                              final v = _formKey.currentState?.value;
                              var result = await _auth.createAcount(v?['user'], v?['pass']);

                              if(result == 1) {
                                //showSnackBar(context, 'Error password demasiado debil. Por favor cambiar');
                              }





                            }
                            /*Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignInView()),
                          ); */
                          },
                          child: Text(
                            "Registro",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Método reutilizable para los campos de texto
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

  // Campo de Fecha de Nacimiento
  Widget _buildDatePickerField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 0.5)),
        ),
        child: GestureDetector(
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Color(0xFF2D9CB1),
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (selectedDate != null) {
              print("Fecha seleccionada: ${selectedDate.toLocal()}");
            }
          },
          child: AbsorbPointer(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.calendar_today),
                hintText: "Fecha de Nacimiento",
                hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
