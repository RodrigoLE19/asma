

/*import 'package:asma/presentation/global/dialogs/custom_navigator_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*class MenuHomeView extends StatefulWidget {
  const MenuHomeView({super.key});

  @override
  State<MenuHomeView> createState() => _MenuHomeViewState();
}*/

class _MenuHomeViewState extends State<MenuHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeViewBody(),
      bottomNavigationBar: CustomNavigatorBar(),
    );
  }
  
}

class _HomeViewBody extends StatefulWidget {
  const _HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _buildEvaluationPage();
      case 1:
        return _buildHistoryPage();
      case 2:
        return _buildProfilePage();
      default:
        return _buildEvaluationPage();
    }

  }

}  */