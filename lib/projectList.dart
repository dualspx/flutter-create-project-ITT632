import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/projectPage.dart';

class ProjectListPage extends StatefulWidget {
  var data;

  ProjectListPage({required this.data});
  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  List<Map<String, dynamic>> _projects = [
    {
      "name": "Project 1",
      "lastModified": "2022-01-01",
      "hasMedia": true,
      "isFavorite": true,
      "deadline": "2022-01-15",
      "members": [
        {"name": "John Doe", "profileImage": 'assets/images/2560.jpg'},
        {"name": "Jane Smith", "profileImage": 'assets/images/2560.jpg'},
        {"name": "Bob Johnson", "profileImage": 'assets/images/2560.jpg'},
      ],
    },
    {
      "name": "Project 2",
      "lastModified": "2022-02-01",
      "hasMedia": false,
      "isFavorite": false,
      "deadline": "2022-03-01",
      "members": [
        {"name": "Mike Brown", "profileImage": 'assets/images/2560.jpg'},
        {"name": "Emily Davis", "profileImage": 'assets/images/2560.jpg'},
        {"name": "Jacob Wilson", "profileImage": 'assets/images/2560.jpg'},
      ],
    },
    // Add more projects here
  ];
  String _selectedFilter = "date";
  bool _showFavorites = false;
  bool _showUpcomingDeadline = false;

  void _onFilterChanged(String newFilter) {
    setState(() {
      _selectedFilter = newFilter;
    });
  }

  void _onFavoriteChanged(bool newValue) {
    setState(() {
      _showFavorites = newValue;
    });
  }

  void _onUpcomingDeadlineChanged(bool newValue) {
    setState(() {
      _showUpcomingDeadline = newValue;
    });
  }

  Widget _buildProjectList() {
    List<Map<String, dynamic>> filteredProjects = _projects;

    if (_showFavorites) {
      filteredProjects =
          filteredProjects.where((project) => project["isFavorite"]).toList();
      filteredProjects.sort((a, b) => a["name"].compareTo(b["name"]));
    }

    if (_showUpcomingDeadline) {
      filteredProjects = filteredProjects
          .where((project) =>
              project["deadline"].isAfter(DateTime.now()) &&
              project["deadline"]
                  .isBefore(DateTime.now().add(Duration(days: 7))))
          .toList();
      filteredProjects.sort((a, b) => a["deadline"].compareTo(b["deadline"]));
    }

    if (_selectedFilter == "date") {
      filteredProjects
          .sort((a, b) => b["lastModified"].compareTo(a["lastModified"]));
    }
    return ListView.builder(
      itemCount: filteredProjects.length,
      itemBuilder: (BuildContext context, int index) {
        final project = filteredProjects[index];
        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                leading:
                    project['hasMedia'] ? Icon(Icons.photo_camera) : SizedBox(),
                title: Text(project["name"]),
                subtitle: Text(
                    "Last modified: ${project["lastModified"].toString()}"),
                trailing: project["isFavorite"]
                    ? Icon(Icons.star, color: Colors.yellow)
                    : Icon(Icons.star_border),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => ProjectPage(
                            name: project["name"],
                            icon: Icons.abc,
                            date: 'Created on 01/01/2022',
                            description: 'test',
                            tasks: [
                              Task(description: 'Task 1', isCompleted: false),
                              Task(description: 'Task 2', isCompleted: true),
                              Task(description: 'Task 3', isCompleted: false),
                            ],
                            pictures: [
                              'assets/images/2560.jpg',
                              'assets/images/2560.jpg',
                              'assets/images/2560.jpg'
                            ],
                            files: [
                              'assets/files/abcdef.txt',
                              'assets/files/abcdef.txt',
                              'assets/files/abcdef.txt',
                            ],
                          )));
                },
              ),
              Container(
                height: 1,
                color: Colors.grey[200],
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    for (int i = 0; i < min(3, project["members"].length); i++)
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    project["members"][i]["profileImage"]),
                                fit: BoxFit.cover)),
                      ),
                    Expanded(
                      child: Container(),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case "delete":
                            _deleteProject(project);
                            break;
                          case "report":
                            _generateProjectReport(project);
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: "delete",
                            child: Text("Delete"),
                            enabled: project["isAdmin"],
                          ),
                          PopupMenuItem<String>(
                            value: "report",
                            child: Text("Generate Report"),
                            enabled: project["isGroupProject"],
                          ),
                        ];
                      },
                      icon: Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteProject(Map<String, dynamic> project) {
    setState(() {
      _projects.remove(project);
    });
// Code to delete the project from the backend
  }

  void _generateProjectReport(Map<String, dynamic> project) {
// Code to generate the report
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _onFilterChanged,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "date",
                  child: Text("Sort by date"),
                ),
                PopupMenuItem<String>(
                  value: "favorite",
                  child: Text("Sort by favorite"),
                ),
                PopupMenuItem<String>(
                  value: "deadline",
                  child: Text("Sort by deadline"),
                ),
              ];
            },
            icon: Icon(Icons.sort),
          ),
          Switch(
            value: _showFavorites,
            onChanged: _onFavoriteChanged,
          ),
          Switch(
            value: _showUpcomingDeadline,
            onChanged: _onUpcomingDeadlineChanged,
          ),
        ],
      ),
      body: _projects == null
          ? Center(child: CircularProgressIndicator())
          : _buildProjectList(),
    );
  }
}
