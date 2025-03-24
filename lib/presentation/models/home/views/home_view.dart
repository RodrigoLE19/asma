
import 'package:asma/main.dart';
import 'package:asma/presentation/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(onPressed: () async {
          Injector.of(context).authenticationRepository.singOut();
          Navigator.pushReplacementNamed(
            context,
            Routes.signIn,
          );
        },
          child: Text('Sing out'),
        ),
      ),
    );
  }
}
