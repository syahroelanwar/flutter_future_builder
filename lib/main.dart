import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Coba FtrBuilder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<Belajar>> _getData() async {
    
    var data = await http.get("http://www.json-generator.com/api/json/get/cgmttEpmPS?indent=2");
    var jData = json.decode(data.body);
    List<Belajar> wyg = [];
    for(var i in jData){
      Belajar w = Belajar(i["index"],i["name"],i["about"],i["email"],i["picture"]);
      wyg.add(w);
    }

    return wyg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot){

            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading...")
                )
              );
            }else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data[index].picture
                      ),
                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                    onTap: (){
                      Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => Detail(snapshot.data[index]))
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      )
    );
  }
}

class Detail extends StatelessWidget {

  final Belajar w;
  Detail(this.w);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(w.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(w.picture),
          Text(w.about),
        ],
      ),
    );
  }
}


class Belajar{
  final int index;
  final String name;
  final String about;
  final String email;
  final String picture;

  Belajar(
    this.index,
    this.name,
    this.about,
    this.email,
    this.picture,
  );
}
