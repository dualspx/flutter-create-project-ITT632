import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/editprofile.dart';
import 'package:frontend/projectList.dart';
import 'main.dart';
import 'package:frontend/project.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class profilePage extends StatelessWidget {
  final storage = const FlutterSecureStorage();
  final Object data;
  profilePage({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    // final profile = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile page'),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (content) => [
              PopupMenuItem(
                value: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: const Text("logout"),
                ),
              ),
            ],
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      extendBody: true,
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1)),
                          ],
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://media.istockphoto.com/id/695645408/photo/nkuringo-family-bwindi-impenetrable-national-park-uganda.jpg?s=612x612&w=0&k=20&c=ySCIHnudSrcx6P4Goxgw4xJTgzFWpAyGHexbbJapRMc='))),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.toString()),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      String? token = await storage.read(key: 'jwt');
                      // debugPrint(jsonEncode(token));
                      // if(token.isEmpty()){

                      // }
                      token = jsonEncode(token);
                      var mapData = <String, dynamic>{};
                      mapData['token'] = token.toString();
                      debugPrint(mapData.toString());
                      final response = await Dio().post(
                          'http://172.31.128.1:3000/editPage',
                          data: mapData);
                      if (response.statusCode == 200) {
                        var data = response.data;
                        // if(mounted){return ;}
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(data: data),
                            ));
                      }
                      // debugPrint(response.data['data']['username'].toString());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Edit Profile",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String? token = await storage.read(key: 'jwt');
                      // debugPrint(jsonEncode(token));
                      // if(token.isEmpty()){

                      // }
                      token = jsonEncode(token);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => project_home(),
                          ));
                    },
                    child: const Text("Create project",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      var response = await Dio().get("http://172.31.128.1:3000/allProject");
                      var data = response.data;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectListPage(data:data),
                          ));
                    },
                    child: const Text("View Project",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.white)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
