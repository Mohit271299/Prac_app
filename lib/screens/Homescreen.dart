import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List <dynamic>dataAPI = [];
  List <dynamic>tempList = [];
  @override
  void initState() {
    super.initState();
    print('Hello');
    fetchAlbum();
  }

  Future fetchAlbum() async {
    var url = 'https://jsonplaceholder.typicode.com/users';
    var response = await http.get(
      Uri.parse(url),
    );
    print(json.decode(response.body.replaceAll('}[]', '}')));
    if (response.statusCode == 200) {
      final Map<String, Object> responseBody =
      json.decode(response.body.replaceAll('}[]', '}'));
      setState(() {
        dataAPI = response.body as List;
        print(dataAPI);
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _searchBar(),
              Expanded(
                flex: 1,
                child: _mainData(),
              )
            ],
          ),
        )
    );
  }

  Widget _mainData(){
    return Center(
      child:  ListView.builder(
          itemCount: dataAPI.length,
          itemBuilder: (context,index){
            return ListTile(
                title: Text(dataAPI[index],)
            );
          }),
    );
  }
  Widget _searchBar(){
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search Dog Breeds Here...",
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (text){
          filterList(text);
        },
      ),
    );
  }

  filterList(String text) {
    if(text.isEmpty){
      setState(() {
        dataAPI = tempList;
      });
    }
    else{
      final List<String> filteredBreeds = <String>[];
      tempList.map((name){
        if(name.contains(text.toString().toUpperCase())){
          filteredBreeds.add(name);
        }
      }).toList();
      setState(() {
        dataAPI = filteredBreeds;
      });
    }
  }
}