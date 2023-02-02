import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_text_viewer/flutter_text_viewer.dart';


class ProjectPage extends StatefulWidget {
   String ? name;
   IconData ? icon;
   String ? date;
   String ? description;
   List<Task> ? tasks;
   List<String> ? pictures;
   List<String> ? files;

  ProjectPage({Key? key, this.name, this.icon, this.date, this.description, this.tasks, this.pictures, this.files}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> with SingleTickerProviderStateMixin {
  TabController ? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name!),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: "Tasks"),
            Tab(text: "Pictures"),
            Tab(text: "Files"),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                ListView.builder(
                  itemCount: widget.tasks!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return CheckboxListTile(
                          title: Text(widget.tasks![index].description!),
                          value: widget.tasks![index].isCompleted,
                          onChanged: (bool ? value) {
                            setState(() {
                              widget.tasks![index].isCompleted = value!;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
                ListView.builder(
                  itemCount: widget.pictures!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(widget.pictures![index],height:50),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: widget.files!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height:200,
                      child: TextViewerPage(
                            textViewer: TextViewer.asset(
                            widget.files![index],
                            highLightColor: Colors.yellow,
                            focusColor: Colors.orange,
                            ignoreCase: true,
                  ),
   showSearchAppBar: false,
   ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
}
class Task {
  String ? description;
  bool isCompleted;

  Task({this.description, this.isCompleted = false});
}