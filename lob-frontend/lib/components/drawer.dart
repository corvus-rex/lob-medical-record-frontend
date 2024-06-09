import 'package:flutter/material.dart';
import 'package:lob_frontend/constants/app_color.dart';
import 'package:lob_frontend/constants/route_names.dart';

class MyDrawer extends StatelessWidget {
  final String routeName;
  final int userType;
  const MyDrawer({
    Key? key,
    required this.routeName,
    required this.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(30),
        color: const Color(0xFFF6F8FB),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              textAlign: TextAlign.start,
              "Dashboard",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.header,
              fontSize: 24,
              )
            ),
            const SizedBox(height: 30),
            if (userType == 1)
              Container(
                decoration: routeName == RoutesName.PATIENT_REG ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                  color: AppColors.selectedBG, 
                ) : null,
                margin: const EdgeInsets.only(top:10),
                child: ListTile(
                  leading:
                    routeName == RoutesName.PATIENT_REG || routeName == '/patient/register' 
                    ? const ImageIcon(color: AppColors.selected, AssetImage('assets/Home_Selected.png')) 
                    : const ImageIcon(AssetImage('assets/Home.png')),
                  title: Text(
                    'Daftar Pasien', 
                    style: TextStyle(
                      color: routeName == RoutesName.PATIENT_REG || routeName == '/patient/register'
                      ? AppColors.selected :AppColors.list
                    )
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.PATIENT_REG);
                  },
                ),
              ),
            const SizedBox(height: 30),
          ]
        ),
      ),
      
    );

  }
}
