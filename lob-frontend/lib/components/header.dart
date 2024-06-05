import 'package:lob_frontend/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lob_frontend/constants/route_names.dart';
import 'package:flutter/scheduler.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(
          width: MediaQuery.of(context).size.width*0.175,
          child: const SizedBox(width: 0)
        ),
        const Spacer(),
        SizedBox(
          width: 287.5,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width > 2000
                ? MediaQuery.of(context).size.width*0.09
                : MediaQuery.of(context).size.width >1550 ? MediaQuery.of(context).size.width*0.1
                : 200,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppColors.element, 
                ),
                margin: const EdgeInsets.only(top:10),
                // child: TextButton(
                //   onPressed: () => {
                //     Navigator.pushNamed(context, RoutesName.NEW_VID)
                //   },
                //   child: const Expanded(child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Text("New Video    ", style: TextStyle(color:Colors.white, fontSize: 18),),
                //       ImageIcon(color: Colors.white, AssetImage('assets/Add.png'))
                //     ],
                //   )),
                // ),
              ),],
          )
        ),
      ],
      );
        
  }

}