import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend/newpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Flutter'),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.ac_unit_sharp),
        ),
      ),
      body: Column(
        children: [
          Image.asset('images/uitm.png'),
          const SizedBox(height: 15),
          const Divider(
            color: Colors.pink,
          ),
          const TextField(
            decoration: InputDecoration(
              labelText: "samad",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: () async{
                    try{
                      var response = await Dio().get("https://jsonplaceholder.typicode.com/albums/1");
                      print(response);
                      // Navigator.push(context,
                      // MaterialPageRoute(builder: (context) => const newPage()));
                    }catch(e){
                      debugPrint(e.toString());
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                  ),
                  child: const Text('Hello'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const newPage()));
                },
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5),
          ),
        ],
      ),
    );
  }
}
