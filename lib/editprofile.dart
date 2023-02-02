import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:frontend/newpage.dart';
import 'package:frontend/profile.dart';
import 'main.dart';

class User {
  late String name = "";
  late String email;
  late String password;
}

class EditProfile extends StatelessWidget {
  bool isObscurePassword = true;
  final storage = const FlutterSecureStorage();
  final data;
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  User _user = User();
  void dispose() {
    //
    _name.dispose();
    _email.dispose();
    _password.dispose();
    dispose();
  }

  EditProfile({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.white),
                            color: Colors.blue),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              buildTextField(
                  _name, "Fullname", data['username'].toString(), false),
              buildTextField(_email, "Email", data['email'].toString(), false),
              buildTextField(
                  _password, "Password", "********".toString(), false),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      debugPrint(data.toString());
                    },
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text("CANCEL",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // var _user.name = _name.text;
                      var mapData = <String, dynamic>{};
                      mapData['_id'] = data["_id"];
                      mapData['username'] = _name.text;
                      mapData['email'] = _email.text;
                      mapData['password'] = _password.text;
                      String? token = await storage.read(key: 'jwt');
                      // debugPrint(jsonEncode(token));
                      token = jsonEncode(token);
                      debugPrint("passing data $mapData");
                      var response = await Dio().put(
                          'http://134.209.107.180:3000/editProfile',
                          data: mapData,
                          options: Options(
                              headers: {'Authorization': 'Bearer $token'}));
                      debugPrint(response.data.toString());
                      if(response.statusCode == 200){
                        // if(){return ;}
                        var data = response.data['username'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => profilePage(data: data)));
                      }else{

                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text("SAVE",
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

  Widget buildTextField(TextEditingController controller, String labelText,
      String placeholder, bool isPasswordTextfield) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          controller: controller,
          validator: (controller)  {
            if(controller == null || controller.isEmpty){
              return "Please enter some text";
            }
            return null;
          },
          obscureText: isPasswordTextfield ? isObscurePassword : false,
          decoration: InputDecoration(
              suffixIcon: isPasswordTextfield
                  ? IconButton(
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        debugPrint(controller.toString());
                      })
                  : null,
              contentPadding: const EdgeInsets.only(bottom: 5),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ));
  }
}
