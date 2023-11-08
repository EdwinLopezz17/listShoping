import 'package:flutter/material.dart';
import 'package:shopinglist/models/ShoppingList.dart';
import 'package:shopinglist/utils/dbhelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: ShowList(),
    );
  }

}

class ShowList extends StatefulWidget {
  const ShowList({super.key});

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  DbHelper helper = DbHelper();

  List<ShoppingList> shoppingList=[];

  @override
  Widget build(BuildContext context) {

    showData();
    return Scaffold(
      body: ListView.builder(
        itemCount: (shoppingList !=null)? shoppingList.length: 0,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(shoppingList[index].name),
          );
        },
      )
    );
  }

  Future showData() async{
    await helper.openDb();

    shoppingList = await helper.getLists();

    setState(() {
      shoppingList = shoppingList;
    });
  }
}
