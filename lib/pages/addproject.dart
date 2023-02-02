import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class addproject extends StatefulWidget {
  @override
  _addproject createState() => _addproject();
}

// Future<List<String>> member() async {
//   var response = await Dio().get("http://172.31.128.1:3000/allMembers");
//   List<String> items = response.data;
//   debugPrint(items.toString());
//   return items;
// }

const storage = FlutterSecureStorage();

class _addproject extends State<addproject> {
  // final data;
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  // final _CreationDate = TextEditingController();
  final _description = TextEditingController();
  final _task = TextEditingController();
  final _memberName = TextEditingController();
  List<String> members = ["Samad","Elvi","Shuk","Adam"];
  List<bool> selection = [false,false,false,false];
  List<String> memberProject = [];
  // bool _isSelected = false;
  // bool _isSelected1 = false;
  // bool _isSelected2 = false;
  // bool _isSelected3 = false;
  late Future<List<String>> dataFuture;
  // @override
  // void initState() {
  //   super.initState();
  //   dataFuture = member();
  // }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SafeArea(
        child: SingleChildScrollView(
            child: Form(
      // key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name(_name),
          const SizedBox(height: 25),
          description(_description),
          const SizedBox(height: 25),
          task(_task),
          const SizedBox(height: 25),
          Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Add Member',
        style: TextStyle(
            color: Color.fromARGB(255, 224, 17, 213),
            fontSize: 16,
            fontWeight: FontWeight.normal),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: _memberName,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black87),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.file_copy,
                color: Color(0xff4281A4),
              ),
              hintText: 'Add Member',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      ),
      ElevatedButton(onPressed: () async{
        var mapData = <String, dynamic>{};
        mapData['name'] = _memberName.text;
        dynamic jsonData = jsonEncode(mapData);
        var response = await Dio().post("http://172.31.128.1:3000/addMember",data:jsonData);
        if(response.statusCode == 200){
          
          memberProject.add(response.data);
          debugPrint(memberProject.toString());
        }
      }, child: const Text("Add member"))
    ],
  ),
          // FutureBuilder<List<String>>(
          //     future: dataFuture,
          //     builder: (context, snapshot) {
          //       debugPrint("CONNECTION ${snapshot.connectionState}");
          //       // debugPrint("DATA ${snapshot.error}");
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         if (snapshot.hasData) {
          //         // List<String>? items = snapshot.data;
          //           return ListView.builder(
          //             // Text("data"),
          //             itemCount: snapshot.data!.length,
          //             itemBuilder: (context, index) {
          //               return CheckboxListTile(
          //                   value: false, onChanged: (bool? value) {});
          //             },
          //           );
          //         }
          //         else if(snapshot.hasError){
          //           return Text("${snapshot.error}");
          //         }

          //       }
          //       else{
          //         debugPrint("CONNECTION ${snapshot.connectionState}");
          //       }
          //       return const CircularProgressIndicator();

          //     }),
          // CheckboxListTile(
          //     title: const Text("Samad"),
          //     value: selection[0],
          //     onChanged: (bool? value) {
          //       setState(() {
          //         selection[0] = value!;
          //       });
                
          //     }),
          // CheckboxListTile(
          //     title: const Text("Elvi"),
          //     value: selection[1],
          //     onChanged: (bool? value) {
          //       setState(() {
          //         selection[1] = value!;
          //       });
          //     }),
          // CheckboxListTile(
          //     title: const Text("Shuk"),
          //     value: selection[2],
          //     onChanged: (bool? value) {
          //       setState(() {
          //         selection[2] = value!;
          //       });
          //     }),
          // CheckboxListTile(
          //     title: const Text("Adam"),
          //     value: selection[3],
          //     onChanged: (bool? value) {
          //       setState(() {
          //         selection[3] = value!;
          //       });
          //     }),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                String? token = await storage.read(key: 'jwt');
                token = jsonEncode(token);
                //to get the admin
                var tokenJSON = <String, dynamic>{};
                tokenJSON['token'] = token;

                // for(int i=0;i<members.length;i++){
                //   if(selection[i] == true){
                //     debugPrint(members[i]);
                //   }
                // }
                // debugPrint("MEMBER $memberProject");
                var responseAdmin = await Dio()
                    .post('http://172.31.128.1:3000/getUser', data: tokenJSON);
                memberProject.add(responseAdmin.data['data']['username']);
                debugPrint(DateTime.now().toString());
                var mapData = <String, dynamic>{};
                mapData['name'] = _name.text;
                mapData['creationDate'] = DateTime.now().toIso8601String();
                mapData['description'] = _description.text;
                mapData['status'] = 'Ongoing';
                mapData['member'] = memberProject;
                mapData['admin'] = responseAdmin.data['data']['username'];
                dynamic jsonData = jsonEncode(mapData);
                debugPrint(memberProject.toString());
                var response = await Dio()
                    .post('http://172.31.128.1:3000/project', data: jsonData);
                if (response.statusCode == 200) {
                  debugPrint(response.data.toString());
                  Navigator.pop(context);
                }
                // member();
              },
              child: const Text('Submit'),
            ),
          ),
          // Column(
          //   children: [
          //     ElevatedButton(
          //         onPressed: () {
          //           // var response =
          //           //     await Dio().get("http://172.31.128.1:3000/allMembers");
          //           // List<dynamic> items = response.data;
          //           // debugPrint(items.length.toString());
          //         },
          //         child: const Text('tekan'))
          //   ],
          // )
        ],
      ),
    )));
  }
}

Future<void> getUser(token) async {
  debugPrint(token);
  // var response = Dio().post('http://172.31.128.1:3000/getUser',data:token);
}

Widget member(TextEditingController controller){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Add Member',
        style: TextStyle(
            color: Color.fromARGB(255, 224, 17, 213),
            fontSize: 16,
            fontWeight: FontWeight.normal),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black87),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.file_copy,
                color: Color(0xff4281A4),
              ),
              hintText: 'Add Member',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      ),
      ElevatedButton(onPressed: () async{
        var response = await Dio().post("http://172.31.128.1:3000/project",data:controller);
        debugPrint(response.statusCode.toString());
      }, child: const Text("Add member"))
    ],
  );
}

Widget name(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Name',
        style: TextStyle(
            color: Color.fromARGB(255, 224, 17, 213),
            fontSize: 16,
            fontWeight: FontWeight.normal),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black87),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.file_copy,
                color: Color(0xff4281A4),
              ),
              hintText: '  Name',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ],
  );
}

Widget description(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Project Description',
        style: TextStyle(
            color: Color.fromARGB(255, 224, 17, 213),
            fontSize: 16,
            fontWeight: FontWeight.normal),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 250,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          style: const TextStyle(color: Colors.black87),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.file_copy,
                color: Color(0xff4281A4),
              ),
              hintText: '  Project Description',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ],
  );
}

Widget task(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Task',
        style: TextStyle(
            color: Color.fromARGB(255, 224, 17, 213),
            fontSize: 16,
            fontWeight: FontWeight.normal),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black87),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.file_copy,
                color: Color(0xff4281A4),
              ),
              hintText: '  Add Task',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ],
  );
}
