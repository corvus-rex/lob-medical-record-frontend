import 'package:flutter/material.dart';
import 'package:lob_frontend/constants/app_color.dart';
import 'package:lob_frontend/constants/route_names.dart';

class MyDrawer extends StatelessWidget {
  final String routeName;
  const MyDrawer({Key? key, required this.routeName}) : super(key: key);

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
              "Workspace",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.header,
              fontSize: 24,
              )
            ),
            const SizedBox(height: 30),
            Container(
              decoration: routeName == RoutesName.HOME ? BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                color: AppColors.selectedBG, 
              ) : null,
              margin: const EdgeInsets.only(top:10),
              child: ListTile(
                leading:
                  routeName == RoutesName.HOME || routeName == '/' 
                  ? const ImageIcon(color: AppColors.selected, AssetImage('assets/Home_Selected.png')) 
                  : const ImageIcon(AssetImage('assets/Home.png')),
                title: Text(
                  'Home', 
                  style: TextStyle(
                    color: routeName == RoutesName.HOME || routeName == '/'
                    ? AppColors.selected :AppColors.list
                  )
                ),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.HOME);
                },
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Videos",
              style: TextStyle(
              color: AppColors.header,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              )
            ),
            // Container(
            //   decoration: routeName == RoutesName.VIDEOS ? BoxDecoration(
            //     borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
            //     color: AppColors.selectedBG, 
            //   ) : null,
            //   margin: const EdgeInsets.only(top:10),
            //   child: ListTile(
            //     leading: 
            //     routeName == RoutesName.VIDEOS 
            //     ? const ImageIcon(color: AppColors.selected, AssetImage('assets/Folder_Selected.png')) 
            //     : const ImageIcon(AssetImage('assets/Folder.png')),
            //     title: Text(
            //       'Videos', 
            //       style: TextStyle(
            //         color: routeName == RoutesName.VIDEOS
            //         ? AppColors.selected :AppColors.list
            //       )
            //     ),
            //     onTap: () {
            //       Navigator.pushNamed(context, RoutesName.VIDEOS);
            //     },
            //   ),
            // ),
            // Container(
            //   decoration: routeName == RoutesName.PREVIEW ? BoxDecoration(
            //     borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
            //     color: AppColors.selectedBG, 
            //   ) : null,
            //   margin: const EdgeInsets.only(top:10),
            //   child: ListTile(
            //     leading: 
            //     routeName == RoutesName.PREVIEW 
            //     ? const ImageIcon(color: AppColors.selected, AssetImage('assets/Preview_Selected.png')) 
            //     : const ImageIcon(AssetImage('assets/Preview.png')),
            //     title: Text(
            //       'Preview', 
            //       style: TextStyle(
            //         color: routeName == RoutesName.PREVIEW
            //         ? AppColors.selected :AppColors.list
            //       )
            //     ),
            //     onTap: () {
            //       Navigator.pushNamed(context, RoutesName.PREVIEW);
            //     },
            //   ),
            // ),
            const SizedBox(height: 30),
            Expanded( 
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Image.asset('assets/Frame_100.png'),
                )
              )
            )
          ]
        ),
      ),
      
    );

  }
}
