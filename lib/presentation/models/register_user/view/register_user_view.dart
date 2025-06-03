import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../domain/enums_account.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../controller/account_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../utils/auth.dart';
import '../../../../domain/models/user.dart';
import '../../../global/controller/session_controller.dart';
import '../../../routes/routes.dart';
import '../../sign_in/controller/sign_in_controller.dart';

class RegisterUserView extends StatefulWidget {
  //const RegisterUserView({super.key});
  @override
  //State<RegisterUserView> createState() => _RegisterUserViewState();
  _RegisterUserViewState createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _dateController = TextEditingController();
  bool _passwordVisible = false;
  bool obscureText = true;
  TextEditingController namesController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController doctor_nameController = TextEditingController();
  TextEditingController doctor_phoneController = TextEditingController();



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

  String? generoValidator(String? value) {
    if (value == null || value.isEmpty || value == "Selecciona tu genero") {
      return "Por favor, selecciona tu genero";
    }
    return null;
  }

  String? dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, ingresa tu fecha de nacimiento";
    }
    try {
      final date = DateFormat('dd/MM/yyyy').parse(value);
      final now = DateTime.now();
      if (date.isAfter(DateTime.now())) {
        return 'La fecha no puede ser futura';
      }

      int age = now.year - date.year;
      if (now.month < date.month || (now.month == date.month && now.day < date.day)) {
        age--;
      }
      if (age < 18) {
        return "Debes tener al menos 18 años";

      }

    } catch (_) {
      return "Formato de fecha invalido (usa dd/MM/yyyy)";
    }
    return null;
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "El campo de nombre esta vacio";
    }
    return null;
  }
  String? lastnameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "El campó de apellido esta vacio";
    }
    return null;
  }
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "El campo de contraseña esta vacio";
    }
    return null;
  }

  @override
  void initState(){
    super.initState();
    passwordController.addListener(() {
      confirmPasswordController.text = passwordController.text;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountUserController>(
      create: (_)=>AccountUserController(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(  // Permite desplazarse cuando aparece el teclado
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
                SizedBox(height: 20),
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
                                final controller= Provider.of<AccountUserController>(context);
                                return AbsorbPointer(
                                  absorbing: controller.fetching,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 1.5)),
                                        ),
                                        child: FormBuilderTextField(
                                          keyboardType: TextInputType.name,
                                          textCapitalization: TextCapitalization.words,
                                          name: 'names',
                                          controller: namesController,
                                          style: TextStyle(color: Color(0xFF145E72)),
                                          validator: nameValidator,
                                          onChanged: (value) {
                                            // Trigger the validation
                                            final formState = _formKey.currentState;
                                            formState?.fields['names']?.validate();
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.person, color: Color(0xFF2D9CB1)),
                                            hintText: "Nombres",
                                            hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
                                            border: InputBorder.none, // Elimina bordes no deseados
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 1.5)),
                                        ),
                                        child: FormBuilderTextField(
                                          keyboardType: TextInputType.name,
                                          textCapitalization: TextCapitalization.words,
                                          name: 'lastname',
                                          controller: lastnameController,
                                          style: TextStyle(color: Color(0xFF145E72)),
                                          validator: lastnameValidator,
                                          onChanged: (value) {
                                            // Trigger the validation
                                            final formState = _formKey.currentState;
                                            formState?.fields['lastname']?.validate();
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.person, color: Color(0xFF2D9CB1)),
                                            hintText: "Apellidos",
                                            hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
                                            border: InputBorder.none, // Elimina bordes no deseados
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 0.0,right: 10),
                                            child: _buildDropdown("Género"),
                                          ),
                                        ),
                                        Expanded(child: Padding(
                                          padding: const EdgeInsets.only(top: 0.0,right: 0),
                                          child: _buildDatePicker(),
                                        ),
                                        ),
                                      ],
                                    ),
                                      SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 1.5)),
                                        ),
                                        child: FormBuilderTextField(
                                          name: 'email',
                                          style: TextStyle(color: Color(0xFF145E72)),
                                          validator: emailValidator,
                                          onChanged: (value) {
                                            controller.onEmailChanged(value!);
                                            // Trigger the validation
                                            final formState = _formKey.currentState;
                                            formState?.fields['email']?.validate();
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.email, color: Color(0xFF2D9CB1)),
                                            hintText: "Correo",
                                            hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
                                            border: InputBorder.none, // Elimina bordes no deseados
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      _buildPasswordField(
                                        controller: passwordController,
                                        name: 'password',
                                        hintText: "Contraseña",
                                        validator: (value) {
                                          final password = _formKey.currentState?.fields['password']?.value;
                                          if (value!= password) {
                                            return 'Las contraseñas no coinciden';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      _buildPasswordField(
                                        controller: confirmPasswordController,
                                        name: 'confirm_password',
                                        hintText: "Confirmar contraseña",
                                        isReadOnly: true,
                                        validator: (value) {
                                          final conf_password = _formKey.currentState?.fields['confirm_password']?.value;
                                          if (value!= conf_password) {
                                            return 'Las contraseñas no coinciden';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 1.5)),
                                        ),
                                        child: FormBuilderTextField(
                                          keyboardType: TextInputType.name,
                                          textCapitalization: TextCapitalization.words,
                                          name: 'doctor_name',
                                          controller: doctor_nameController,
                                          style: TextStyle(color: Color(0xFF145E72)),
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.person, color: Color(0xFF2D9CB1)),
                                            hintText: "Nombre de su médico (opcional)",
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
                                          keyboardType: TextInputType.phone,
                                          textCapitalization: TextCapitalization.words,
                                          name: 'doctor_phone',
                                          controller: doctor_phoneController,
                                          style: TextStyle(color: Color(0xFF145E72)),
                                          onChanged: (value) {
                                            if(value!.length>=9){
                                              FocusScope.of(context).unfocus();
                                            }
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.phone, color: Color(0xFF2D9CB1)),
                                            hintText: "Teléfono de su médico (opcional)",
                                            hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
                                            border: InputBorder.none, // Elimina bordes no deseados
                                            prefixText: '+51 ',
                                          ),
                                          //initialValue: '+51',
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      if (controller.fetching)
                                        CircularProgressIndicator()
                                      else
                                        MaterialButton(
                                          onPressed: () async {
                                            
                                            _formKey.currentState?.save();
                                            if (_formKey.currentState!.validate() ==
                                                true) {
                                              _formKey.currentState?.value;
                                              _submitRegisterUserAccount(context);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text("Campos vacios")));
                                              
                                            }
                                          },
                                          child: Text(
                                            "Registrarte",
                                            
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
                                      SizedBox(height: 20,),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(context, Routes.signIn);
                                          // Navigator.popAndPushNamed(context, registrarusuario.routename);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF2E7B8A),
                                          minimumSize: Size(250, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                        ),
                                        child: Text(
                                            "Ir a iniciar sesion",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String name,
    required String hintText,
    bool isReadOnly = false,
    FormFieldValidator<String>? validator,
  }) {
    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 1.5)),
      ),
      child: FormBuilderTextField(
        controller: controller,
        name: name,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
          //filled: true,
          fillColor:  Color(0xFF2D9CB1),
          prefixIcon: Icon(Icons.lock, color: Color(0xFF2D9CB1),),
          suffixIcon: !isReadOnly
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF2D9CB1),
            ),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Color(0xFF145E72)),
        validator: passwordValidator,
        onChanged: (value) {
          // Trigger the validation
          final formState = _formKey.currentState;
          formState?.fields['password']?.validate();
          formState?.fields['confirm_password']?.validate();
          if(value!.length>=8){
            FocusScope.of(context).unfocus();
          }
        },
        readOnly: isReadOnly,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 1.5)),
        ),
        child: GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
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
            if (pickedDate != null) {
              setState(() {
                _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
              });
            }
          },
          child: AbsorbPointer(
            child: FormBuilderTextField(
              controller: _dateController,
              name: 'date',
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF2D9CB1)),
                hintText: "Fecha de Nacimiento",
                hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 12, color: Color(0xFF145E72)),
              validator: dateValidator,
              readOnly: true,
              onChanged: (value) {
                final formState = _formKey.currentState;
                formState?.fields['date']?.validate();
              },
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildDropdown(String hintText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF2D9CB1), width: 1.5)),
        ),
        child: FormBuilderDropdown<String>(
          name: 'gender',
          initialValue: null,
          isExpanded: true,
          hint: Text(hintText, style: TextStyle(color: Color(0xFF2D9CB1))),
          //dropdownColor: Colors.white,
          decoration: InputDecoration(
            hintText: hintText,
            //hintStyle: TextStyle(color: Color(0xFF2D9CB1)),
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            alignLabelWithHint: true,
            //filled: true,
            //fillColor: Colors.black,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0), // Ajusta el relleno para alinear el texto

          ),
          style: TextStyle(fontSize: 15, color: Color(0xFF145E72)),
          items: ["Masculino", "Femenino"]
              .map((label) => DropdownMenuItem(
            child: Text(label, style: TextStyle(color: Color(0xFF2D9CB1))),
            value: label,
          ))
              .toList(),
          validator: generoValidator,
          onChanged: (value){
            final formState = _formKey.currentState;
            formState?.fields['gender']?.validate();
          },
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF2D9CB1)), // Asegura que la flecha esté alineada

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

  Future<void> _submitAccountUser(BuildContext context,String names,String lastname,String gender,String birthday, String doctorName, String doctorPhone)async{
    final SignInController controller= context.read();
    controller.onFetchingChanged(true);
    final result=await context.read<AccountRepository>().createUserAccountFirebase(
        controller.email,
        '12345678',
        names,
        lastname,
        gender,
        birthday,
        doctorName,
        doctorPhone
    );
    if(!mounted){
      return;
    }
    result.when(
          (failure){
        controller.onFetchingChanged(false);
        final meesage={
          AccountUserFailure.passwordWeak:'Contraseña demasiado débil',
          AccountUserFailure.emailAlreadyRegistered:'Correo electronico ya registrado',
          AccountUserFailure.UnknownFirebaseAuthException:'Error Desconocido',
        } [failure];
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(meesage!))
        );
      },
          (user){
        SessionController sessionController=context.read();
        sessionController.setUser(user);
        Navigator.pushReplacementNamed(
            context,
            Routes.menu_home,
            arguments: {'typeLogin':'FA'}
        );
      },
    );
  }
  Future<void> _submitRegisterUserAccount(BuildContext context) async {
    final AccountUserController controller = context.read<AccountUserController>();
    controller.onFetchingChanged(true);
    final v=_formKey.currentState?.value;
    try {
      var result = await context
          .read<AuthenticationRepository>()
          .createFirebaseAccountUser(
        controller.email,
        passwordController.text,
      );

      if (!mounted) {
        return;
      }

      print(result);
      result.when(
            (failure) {
          controller.onFetchingChanged(false);
          final message = {
            AccountUserFailure.emailAlreadyRegistered: 'Correo electrónico ya registrado',
            AccountUserFailure.passwordWeak: 'Contraseña demasiado débil',
          }[failure];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message!)),
          );
        },
            (userUid) async {
              final v = _formKey.currentState?.value;
              String doctorPhone = v?['doctor_phone'] ?? '';
              doctorPhone = doctorPhone.replaceAll(RegExp(r'\D'), ''); 

              if (doctorPhone.isNotEmpty && !doctorPhone.startsWith('51')) {
                doctorPhone = '51' + doctorPhone;
              }
          final userData = {
            'names': v?['names'],
            'lastname': v?['lastname'],
            'displayName': v?['names']+' '+v?['lastname'],
            'gender': v?['gender'],
            'birthday': v?['date'],
            'email': controller.email,
            'password': passwordController.text,
            'doctor_name': v?['doctor_name'],
            'doctor_phone': doctorPhone,
          };
          await FirebaseFirestore.instance.collection('user').doc(userUid).set(userData);
          controller.onFetchingChanged(false);
          SessionController sessionController = context.read<SessionController>();
          sessionController.setUser(User(
            uid: userUid,
            names: v?['names'],
            lastName: v?['lastname'],
            displayName: v?['names']+' '+v?['lastname'],
            gender: v?['gender'],
            birthday: v?['date'],
            email: controller.email,
            doctorName: v?['doctor_name'], 
            doctorPhone: doctorPhone,
          ));
          controller.onFetchingChanged(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("USUARIO REGISTRADO CORRECTAMENTE")),
          );
          Navigator.pushReplacementNamed(
              context,
              Routes.menu_home,
              arguments: {'typeLogin':'FA'}
          );
        },
      );
    } catch (e) {
      controller.onFetchingChanged(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ocurrió un error: $e")),
      );
    }
  }
}
