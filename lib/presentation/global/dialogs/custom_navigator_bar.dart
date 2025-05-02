import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/menu_home_provider_controller.dart';

class CustomNavigatorBar extends StatelessWidget {
  const CustomNavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<MenuHomeProviderController>(context);
    final currentIndex = uiProvider.seleccionMenu;

    return BottomNavigationBar(
      onTap: (int i) => uiProvider.seleccionMenu = i,
      currentIndex: currentIndex,
      selectedFontSize: 12,
      backgroundColor: Color(0xFF2D9CB1),
      elevation: 20.0,
      iconSize: 30,
      selectedItemColor: Color(0xFF003E49),
      unselectedItemColor: Colors.white,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: [
        _buildBottomNavigationBarItem(
          icon: Icons.local_hospital,
          label: "Evaluacion",
          isSelected: currentIndex == 0,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.history,
          label: "Historial Evaluaciones",
          isSelected: currentIndex == 1,
        ),
        /*_buildBottomNavigationBarItem(
          icon: Icons.assessment,
          label: "Estadisticas",
          isSelected: currentIndex == 2,
        ),*/
        _buildBottomNavigationBarItem(
          icon: Icons.person,
          label: "Perfil",
          isSelected: currentIndex == 2,
        ),
      ],
    );
  }
  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        /*decoration: BoxDecoration(
          color: isSelected ? Colors.grey : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),*/
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      label: label,
      backgroundColor: isSelected ? Colors.blue : Colors.transparent,
    );
  }
  }




